class WebJob < ActiveRecord::Base
  defaults :format_num => "%03d", :start_num_img => "1"
  
  attr_accessor :count_num_img
  attr_accessor :start_num_gal
  attr_accessor :count_num_gal

  validates_presence_of :category, :name, :source
  
  state_machine :state, :initial => :pending do

    state :pending
    state :queuing
    state :running
    state :done

    state :returned

    event :start do
      transition :pending => :queuing
      transition :queuing => :running
    end
    after_transition :queuing => :running do |job, transition|
      job.run
    end

    event :finish do
      transition :running => :done
    end

  end

  def run
    # start wget :)
  end

  def generate
    urls = source.split(/\n/)
    result = []
    urls.each do |url|
      result << get_splited_data(url)
    end
    self.body = result.join("\n")
  end

  def get_splited_data url
    result = []
    ext = url.split(".").last
    part_url = url.split(".#{ext}").first
    start_num, end_num, url = get_start_end(part_url)
    (start_num..end_num).each do |index|
      result << "#{url}#{sprintf(self.format_num, index)}.#{ext}"
    end
    result.join("\n")
  end

  def get_start_end part_url, split_char="-"
    result, s_char = part_url.split(split_char).try(:last), split_char
    result, s_char = part_url.split("/").try(:last), "/" if result.to_i == 0
    url = part_url.split(s_char)
    url.delete(url.last)
    [start_num_img.to_i, result.try(:to_i), "#{url.join(s_char)}#{s_char}"]
  end
  
  def create_directory
    FileUtils.mkdir_p "#{dest_dir}/log"    
  end
  
  def write_body
    File.new(urls_file_path, "w+").write(self.body)
  end
  
  def urls_file_path
    dest_dir + "/urls.txt"
  end

  def log_dir_path
    dest_dir + "/log"
  end
  
  def dest_dir
    RAILS_ROOT + "/public/downloads/#{self.category}/#{self.id}"
  end
end
