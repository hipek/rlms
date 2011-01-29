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

  def stub_shell_commands
    Service.stub!(:find_by_name).and_return(mock('service', :bin_path => '', :config_path => '/tmp', :init_path => '/tmp'))
    ShellCommand.stub!(:run_command).and_return('')
  end

  def array_to_will_paginate elements, page=1, per_page=100
    WillPaginate::Collection.new(page, per_page, elements.length).concat(elements)
  end

  def add_permission group, permission
    Permission.find_or_create_by_group_id_and_action(group.id, permission)
  end

  protected

  def stub_others object, options={}
    object.stub!(:id).and_return(options[:id]) if options[:id].present?
    object
  end
end
