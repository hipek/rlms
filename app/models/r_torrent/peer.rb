class RTorrent::Peer < RTorrent::Base
  METHODS = {
    :get_address= => :address,
    :get_client_version= => :client_version,
    :get_completed_percent= => :completed_percent,
    :get_down_rate= => :down_rate,
    :get_down_total= => :down_total,
    :get_id= => :id,
    :get_id_html= => :id_html,
    :get_options_str= => :options_str,
    :get_peer_rate= => :peer_rate,
    :get_peer_total= => :peer_total,
    :get_port= => :port,
    :get_up_rate= => :up_rate,
    :get_up_total= => :up_total,
    :is_encrypted= => :encrypted,
    :is_incoming= => :incoming,
    :is_obfuscated= => :obfuscated,
    :is_snubbed= => :snubbed,
  }.freeze

  attr_accessor *METHODS.values

  def initialize args=nil
    return if args.nil?
    METHODS.values.each_with_index do |m, i|
      send(:"#{m.to_s}=", args[i])
    end
  end

  def self.remote_methods
    METHODS.keys.map{|k| "#{prefix}#{k.to_s}="}
  end
  
  def self.prefix
    "p."
  end
  
  def completed_percent
    @completed_percent.to_s + "%"
  end
end
