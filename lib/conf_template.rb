require "erb"

class ConfTemplate
  attr_accessor :name
  attr_reader :data
  
  def initialize t_name, options={}
    @name = t_name
    @data = options
  end

  def get_binding
    binding
  end

  def read_file
    File.new(template_path, "r").read
  end

  def render
    ERB.new(read_file).result get_binding
  end

  def dest_path
    RAILS_ROOT + "/tmp/#{name}"
  end

  def write_tmp_file
    f = File.new(dest_path, "w")
    f.write(render)
    f.close
  end

  alias_method :write, :write_tmp_file
  
  def self.ftime
    Time.now.strftime("%Y%m%d%H%M%S")
  end
  
  protected

  def template_path
    RAILS_ROOT + "/lib/conf_templates/#{name}.erb" 
  end
end
