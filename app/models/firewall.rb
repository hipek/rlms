class Firewall < ActiveRecord::Base
  belongs_to :lan, :class_name => 'LocalNetwork', :foreign_key => 'lan_id'

  has_many :fw_rules

  named_scope :lan, lambda {|l| { :conditions => {:lan_id => l.id} }}

  delegate :ext_inf, :to => :lan
  delegate :ext_ip, :to => :lan
  delegate :auto_ext_ip, :to => :lan  
  delegate :int_inf, :to => :lan
  delegate :int_ip, :to => :lan
  delegate :auto_int_ip, :to => :lan

  def self.all_as_pairs
    find(:all).map{|f| [f.name,f.id] }
  end
  
  def blocking_ip_port
    "#{auto_int_ip}:9000"
  end
  
  def write_tmp_file
    File.new(dest_path, "w").write(ShellCommand.ip_tables_save(nil))
  end
  
  def dest_path
    RAILS_ROOT + "/tmp/iptables.conf"
  end
end
