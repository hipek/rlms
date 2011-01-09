class RTorrent::Tracker < RTorrent::Base
  METHODS = {
    :get_group= => :group,
    :get_id= => :id,
    :get_min_interval= => :min_interval,
    :get_normal_interval= => :normal_interval,
    :get_scrape_complete= => :scrape_complete,
    :get_scrape_downloaded= => :scrape_downloaded,
    :get_scrape_time_last= => :scrape_time_last,
    :get_type= => :t_type,
    :get_url= => :url,
    :is_enabled= => :enabled,
    :is_open= => :open,
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
    "t."
  end

end
