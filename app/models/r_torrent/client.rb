class RTorrent::Client < RTorrent::Base
  METHODS = { 
    'system.listMethods' => :list_methods,
    'view_list' => :list_views,
    'get_upload_rate' => :upload_rate,
    'get_download_rate' => :download_rate,
    'get_up_rate' => :up_rate,
    'get_down_rate' => :down_rate,
  }.freeze

  METHODS.each do |remote_method, local_method|
    class_eval "
      def self.#{local_method}
        call('#{remote_method}')
      end"
  end

  class << self
    def raw_items view="main"
      call(*(['d.multicall', view] + RTorrent::Item.remote_methods))
    end

    def items
      i = []
      raw_items.each do |item|
        i << RTorrent::Item.new(item)
      end
      i
    end

    def find_method name
      list_methods.select{|m| m.match(/#{name}/)}
    end

    def show_help method_name
      call('system.methodHelp', method_name.to_s)
    end

    def upload torrents
      torrents.each{|t| save_in_watch_dir(t)} unless torrents.nil?
    end

    def save_in_watch_dir data
      return if data.blank?
      name =  data.original_filename
      path = File.join(watch_path, name)
      File.open(path, "wb") { |f| f.write(data.read) }
    end
    
    def load_start url
      return nil if url.blank?
      call('load_start', url).to_s
    end

    %w(download upload).each do |opt|
      class_eval "
      def set_#{opt}_rate rate
        return if rate.blank?
        call('set_#{opt}_rate', prepare_rate(rate))
      end"
    end

    def prepare_rate rate
      (rate.downcase.gsub('kb','').to_f*1024).to_i
    end
  end
end
