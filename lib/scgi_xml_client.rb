require 'xmlrpc/client'
require 'xmlrpcs'
require 'socket'

class SCGIXMLClient < XMLRPC::ClientS
  def new_socket( info, async )
    socket = Socket.new Socket::AF_INET, Socket::SOCK_STREAM
    socket.connect Socket.pack_sockaddr_in info.first[:port], info.first[:host]
    SCGIWrappedSocket.new(socket, info.last)
  end
end

class SCGIWrappedSocket
  attr_accessor :sock, :uri, :method
  
  def initialize( sock, uri, method="POST" )
    @sock, @uri, @method = sock, uri, method
  end
  
  def write(x)
    msg = SCGI::Wrapper.wrap(x,@uri,@method)
    r = @sock.write(msg)
    if r != msg.length then
      raise IOException, "Not all the data has been sent (#{r}/#{msg.length})"
    end 
    return x.length
  end 
  
  def read()
    data = @sock.read()
    # receiving an html response (very dumb parsing)
    # divided in 2
    # 1 -> status + headers
    # 2 -> data
    return data.split("\r\n\r\n").last
  end
end

module SCGI
  class Wrapper
    def self.wrap( content, uri, method="POST", headers=[] )
      null="\0"
      header = "CONTENT_LENGTH\0#{content.length}\0SCGI#{null}1\0REQUEST_METHOD\0#{method}\0REQUEST_URI\0#{uri}\0"
      headers.each do |h,v|
        header << "#{h}\0#{v}\0"
      end
      return "#{header.length}:#{header},#{content}"
    end
  end
end
