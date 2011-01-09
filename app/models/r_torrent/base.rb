class RTorrent::Base
  SOCKET_PATH = YAML.load_file(RAILS_ROOT + '/config/rtorrent.yml')['socket']
  WATCH_PATH = YAML.load_file(RAILS_ROOT + '/config/rtorrent.yml')['watch']

  def call *args
    self.class.call(*args)
  end

  def self.call *args
    service.call(*args)
  end

  def self.watch_path
    WATCH_PATH
  end

  protected

  def service
    self.class.service
  end

  def self.service
    @@service ||= SCGIXMLClient.new([SOCKET_PATH, "/RPC2"])
  end
end
