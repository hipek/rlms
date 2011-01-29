module Factory
  def build_router_interface options={}
    stub_others Router::Interface.new({
      :ip_address => '10.5.5.10',
      :ip_mask => '255.0.0.0',
      :name => 'eth0',
      :config => 'manually'
    }.merge(options)), options
  end

  def build_router_main(options={})
    stub_others Router::Main.new({
      :dns_server1 => '194.204.159.1',
      :dns_server2 => '194.204.159.1',
      :name => 'localhost.localdomain',
      :interfaces => [
        build_router_interface(:net_type => 'ext', :name => 'eth1'),
        build_router_interface(:net_type => 'int', :name => 'eth0')
      ]
    }.merge(options)), options
  end

  def build_router_dhcp(options={})
    stub_others Router::Dhcp.new({
       :router => build_router_main,
       :gateway => '10.5.5.1',
       :subnet => '10.0.0.0',
       :broadcast_address => '10.255.255.255',
       :range_from => '10.5.5.10',
       :range_to => '10.5.5.20',
       :subnet_mask => '255.0.0.0',
       :domain_name_server1 => '194.204.159.1',
       :domain_name_server2 => '194.204.152.34',
     }.merge(options)), options
  end

  protected

  def stub_others object, options={}
    object.stub!(:id).and_return(options[:id]) if options[:id].present?
    object
  end
end
