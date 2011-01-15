class RTorrent::Base
  CONFIG = Rails.root.join('config', 'rtorrent.yml')
  SOCKET_PATH = YAML.load_file(CONFIG)['socket']
  WATCH_PATH = YAML.load_file(CONFIG)['watch']

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
