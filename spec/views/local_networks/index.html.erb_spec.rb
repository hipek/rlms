require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/local_networks/index.html.erb" do
  include LocalNetworksHelper
  
  before(:each) do
    assigns[:local_network] = build_local_network
    assigns[:interfaces] = ["eth0", "wlan0"]
  end

  it "should render list of local_networks" do
    render "/local_networks/index.html.erb"
    response.capture(:col2).should have_tag("form[action=?][method=post]", local_network_path(0)) do
      with_tag("input#local_network_name[name=?]", "local_network[name]")
      with_tag("select#local_network_int_inf[name=?]", "local_network[int_inf]")
      with_tag("select#local_network_ext_inf[name=?]", "local_network[ext_inf]")
      with_tag("input#local_network_int_ip[name=?]", "local_network[int_ip]")
      with_tag("input#local_network_ext_ip[name=?]", "local_network[ext_ip]")
    end
  end
end

