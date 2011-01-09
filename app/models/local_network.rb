class LocalNetwork < BaseSetting
  has_many :dhcp_servers, :class_name => 'DhcpServer', :foreign_key => 'lan_id'
  has_many :firewalls, :class_name => 'Firewall', :foreign_key => 'lan_id'

  define_fields :name => 'local.network', :int_inf => 'eth0', :ext_inf => 'eth1', :int_ip => 'auto', :ext_ip => 'auto'
  define_instance_methods

  def self.first
    find(:first) || LocalNetwork.new
  end

  def default_firewall
    Firewall.new :lan => LocalNetwork.first
  end
  
  def auto_ext_ip
    ext_ip == 'auto' ? ShellCommand.ip(ext_inf) : ext_ip
  end
  
  def auto_int_ip
    int_ip == 'auto' ? ShellCommand.ip(int_inf) : int_ip
  end  
end
