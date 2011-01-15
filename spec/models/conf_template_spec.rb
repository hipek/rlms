require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConfTemplate do
  fixtures :computers

  before :each do
    @conf_template = ConfTemplate.new('dhcpd.conf', 
                                      :computers => [computers(:one), computers(:two)], 
                                      :dhcp => build_dhcp_server)
  end

  it "should return new object" do
    @conf_template.class.should == ConfTemplate
    @conf_template.name.should == "dhcpd.conf"
  end

  it "should return string value of template" do
    @conf_template.read_file.should include("ddns-update-style ad-hoc")
    @conf_template.read_file.class.should == String    
  end

  it "should render erb file" do
    @conf_template.render.should include(computers(:one).mac_address)
    @conf_template.render.should include(computers(:two).ip_address)
    @conf_template.render.should include(build_dhcp_server.router)
  end
  
  it "should return path to rendered file" do
    @conf_template.dest_path.should == Rails.root.join("tmp", "dhcpd.conf")
  end
  
  it "should save rendered file in tmp dir" do
    @conf_template.write
    File.exist?(@conf_template.dest_path).should be_true
    File.delete(@conf_template.dest_path)
  end
end
