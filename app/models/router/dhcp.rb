class Router::Dhcp < Router::BaseSetting
  define_fields :gateway => nil, :subnet => nil, :broadcast_address => nil, 
    :range_from => nil, :range_to => nil, :subnet_mask => nil, 
    :domain_name_server1 => nil, :domain_name_server2 => nil,
    :default_lease_time => '8600', :max_lease_time => '8600'

  validates_format_of :subnet, :broadcast_address, 
    :range_from, :range_to, :subnet_mask, :domain_name_server1,
    :with => /\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/

  belongs_to :router, :class_name => 'Router::Main', :foreign_key => 'parent_id'

  class <<self
    def instance
      first || new(Router::Main.instance.dhcp_attrs)
    end
  end

  def domain_name
    router.name
  end

  def domain_name_servers
    [domain_name_server1, domain_name_server2]
  end

  def install_conf
    dhcpd_conf = ConfTemplate.new("dhcpd.conf", :computers => Computer.all_for_dhcpd, :dhcp => self)
    dhcpd_conf.write
    dhcpd_conf
  end
end
