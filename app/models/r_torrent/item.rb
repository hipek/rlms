class RTorrent::Item < RTorrent::Base
  METHODS = {
    :get_creation_date => :creation_date,
    :get_free_diskspace => :free_diskspace,
    :get_base_filename => :base_filename,
    :get_base_path => :path,
    :get_directory => :directory,
    :get_message => :message,
    :get_hash => :hash,
    :get_hashing => :hashing,
    :get_name => :name,
    :get_left_bytes => :bytes_left,
    :get_size_bytes => :bytes_size,
    :get_chunk_size => :chunk_size,
    :get_size_chunks => :size_chunks,
    :get_completed_chunks => :completed_chunks,
    :get_down_rate => :down_rate,
    :get_up_rate => :up_rate,
    :get_priority => :priority,
    :get_connection_current => :connection_current,
    :get_complete => :complete,
    :get_local_id => :local_id,
    :is_active => :active,
    :is_multi_file => :multi_file,
  }.freeze

  PRIORITIES = { 
    'off' => 0,
    'low' => 1,
    'normal' => 2,
    'high' => 3,
  }
  
  attr_accessor *METHODS.values
  attr_accessor :torrent_url
  alias_method :id, :hash
  alias_method :to_param, :id

  class << self
    def remote_methods
      METHODS.keys.map{|k| "d.#{k.to_s}="}
    end
  end
  
  def initialize args=nil
    return if args.nil?
    METHODS.each_with_index do |m, i|
      arg = args.is_a?(String) ? call("d.#{m.first}", args) : args[i]
      send(:"#{m.last.to_s}=", arg)
    end
  end

  def raw_elements element_type
    call(*(["#{element_type.prefix}multicall", hash, ''] + element_type.remote_methods))
  end

  def mapped_elements element_type
    raw_elements(element_type).map{|r| element_type.new(r)}
  end
  
  def trackers
    mapped_elements(RTorrent::Tracker)
  end 
  
  def peers
    mapped_elements(RTorrent::Peer)
  end
  
  def files
    raw_elements(RTorrent::File).map{|r| RTorrent::File.new(r, hash)}
  end
  
  def bytes
    size_chunks * chunk_size
  end

  def percent_complete
    ((bytes_completed.to_f/bytes.to_f) * 100).to_i.to_s + '%'
  end

  def bytes_completed
    completed_chunks * chunk_size
  end
  
  def status
    s = "Downloading"
    s = "Stopped" unless active?
    s = "Complete" if complete?
    s = "Hashing" if hashing > 0
    s
  end

  def conn_type
    s = ""
    s = "Leeching" if active? && connection_current == "leech"
    s = "Seeding" if active? && connection_current == "seed"
    s
  end

  def active?
    active == 1
  end

  def complete?
    complete == 1
  end

  def start
    call('d.start', hash)
  end

  def stop
    call('d.stop', hash)
  end

  def close
    call('d.close', hash)
  end

  def destroy
    call('d.erase', hash)
  end
  alias_method :delete, :destroy
  
  def set_priority prio
    call("d.set_priority", hash, prio.to_i)
  end
  
  def created_at
    Time.at(creation_date).strftime("%d/%m/%Y %H:%M:%S")
  end
  
  def display_priority
    PRIORITIES.index(priority)
  end
  
  def eta
    dw_r = down_rate == 0 ?  0.01 : down_rate
    (bytes - bytes_completed)/dw_r
  end
  
  def time_left
    t = eta
    return t.to_s + 's' if t < 60
    return (t/60).to_s + 'min' if t < 3600
    return (t/3600).to_s + 'h' if t < 3600*24
    result = (t/(3600*24))
    result > 100 ? '--' : result.to_s + 'd'
  end
end
