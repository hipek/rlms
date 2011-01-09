require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/dhcp_servers/index.html.erb" do
  include DhcpServersHelper
  
  before(:each) do
    assigns[:dhcp_server] = build_dhcp_server
  end

  it "should render list of dhcp_servers" do
    render "/dhcp_servers/index.html.erb"
    
    response.capture(:col2).should have_tag("form[action=#{dhcp_server_path(0)}][method=post]") do
      with_tag('input#dhcp_server_domain_name_server1[name=?]', "dhcp_server[domain_name_server1]")
      with_tag('input#dhcp_server_domain_name_server2[name=?]', "dhcp_server[domain_name_server2]")
      with_tag('input#dhcp_server_subnet_mask[name=?]', "dhcp_server[subnet_mask]")
      with_tag('input#dhcp_server_default_lease_time[name=?]', "dhcp_server[default_lease_time]")
      with_tag('input#dhcp_server_max_lease_time[name=?]', "dhcp_server[max_lease_time]")
      with_tag('input#dhcp_server_subnet[name=?]', "dhcp_server[subnet]")
      with_tag('input#dhcp_server_broadcast_address[name=?]', "dhcp_server[broadcast_address]")
      with_tag('input#dhcp_server_router[name=?]', "dhcp_server[router]")
      with_tag('input#dhcp_server_range_from[name=?]', "dhcp_server[range_from]")
      with_tag('input#dhcp_server_range_to[name=?]', "dhcp_server[range_to]")
    end
  end
end

