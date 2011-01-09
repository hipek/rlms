class RTorrent::File < RTorrent::Base
  METHODS = {
    :get_completed_chunks => :completed_chunks,
    :get_frozen_path => :frozen_path,
    :is_created => :created,
    :is_open => :open,
    :get_last_touched => :last_touched,
    :get_match_depth_next => :match_depth_next,
    :get_match_depth_prev => :match_depth_prev,
    :get_offset => :offset,
    :get_path => :path,
    :get_path_components => :path_components,
    :get_path_depth => :path_depth,
    :get_priority => :priority,
    :get_range_first => :range_first,
    :get_range_second => :range_second,
    :get_size_bytes => :size_bytes,
    :get_size_chunks => :size_chunks,
  }.freeze

  PRIORITIES = { 
    'off' => 0,
    'normal' => 1,
    'high' => 2,
  }
  
  attr_accessor *METHODS.values
  attr_accessor :hash, :chunk_size
  alias_method :id, :hash

  def initialize args=nil, hash=nil
    return if args.nil?
    METHODS.values.each_with_index do |m, i|
      send(:"#{m.to_s}=", args[i])
    end
    self.hash = hash
    self.chunk_size = call('d.get_chunk_size', hash)
  end
  
  def bytes
    size_chunks * chunk_size
  end

  def bytes_completed
    completed_chunks * chunk_size
  end
  
  def percent_complete
    ((completed_chunks.to_f/size_chunks.to_f) * 100).to_i.to_s + '%'
  end
  
  def self.remote_methods
    METHODS.keys.map{|k| "#{prefix}#{k.to_s}="}
  end
  
  def self.prefix
    "f."
  end
  
  def set_priority index, prio
    call("f.set_priority", hash, index, prio.to_i)
  end
end
