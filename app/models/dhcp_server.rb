class DhcpServer < BaseSetting
  define_fields :router => nil, :subnet => nil, :broadcast_address => nil, 
    :range_from => nil, :range_to => nil, :subnet_mask => nil, 
    :domain_name_server1 => '194.204.159.1', :domain_name_server2 => '194.204.152.34',
    :default_lease_time => '8600', :max_lease_time => '8600'

  validates_format_of :router, :subnet, :broadcast_address, 
    :range_from, :range_to, :subnet_mask, 
    :domain_name_server1, :domain_name_server2,
    :with => /\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/

  def self.first
    find(:first) || DhcpServer.new(:router => LocalNetwork.first.auto_int_ip)
  end
  
  def domain_name
    LocalNetwork.first.name
  end
  
  def domain_name_servers
    [domain_name_server1, domain_name_server2]
  end
  
  def install_conf
    dhcpd_conf = ConfTemplate.new("dhcpd.conf", :computers => Computer.all_for_dhcpd, :dhcp => self)
    dhcpd_conf.write
    dhcpd_conf
  end
  
  def gateway
    router
  end
end
