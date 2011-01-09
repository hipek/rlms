require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DhcpServer do
  before(:each) do
    @dhcp_server = build_dhcp_server
  end

  it "should be valid" do
    @dhcp_server.should be_valid
  end
end
