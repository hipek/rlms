require 'xmlrpc/client'

# This gems allow to easily change the transport layer in XMLRPC::Client class.
# It adds a new class called XMLRPC::ClientS, subclass of the Client class.

module XMLRPC

  # This class must be subclassed to put your own transport code in it.
  # There are 3 private method that are to be changed.
  #
  # new_socket +MUST+ be redefined or will raise a NotImplementedError, while
  # write_request and read_response have to be changed to use a specific
  # protocol, the default is that there is no control on the write operation
  # and the receiving the response is ended by the closoure of the socket.  In
  # the test i use a very simple protocol for instance which needs no
  # explanation.
  
  class ClientS < XMLRPC::Client
    
    # The info parameter will be passed to the new_socket function as it is
    def initialize(info=nil)
      @info = info
    end
    
    private
    
    # This is called to create a new socket. Info is the parameter you
    # passed to the constructor and async is a boolean value that tells you
    # if the socket should be asyncrhonous.  The object returned must answer
    # to read and write methods.
    def new_socket(info,async) # :doc:
      raise NotImplementedError, "new_socket must be redefined"
    end
    
    # Writes the request in the socket, this may be left as it is.
    def write_request(socket,request) # :doc:
      if socket.write(request) != request.length then
        raise IOError, "Not all the data has been sent"
      end
    end
    
    # Must read the response from the socket and return the data. You may
    # leave this the default, the default behavious is to wait until the
    # socket is closed.
    def read_response(socket) # :doc:
      socket.read()
    end
    
    # do_rpc working with custom sockets
    def do_rpc( request, async )
      sock = new_socket(@info,async)
      write_request(sock,request)
      return read_response(sock)
    end
  end
end
