require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConfTemplate do
  describe 'Dhcp config' do
    before :each do
      @conf_template = ConfTemplate.new('dhcpd.conf', 
                                        :computers => [build_router_computer], 
                                        :dhcp => build_router_dhcp)
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
      @conf_template.render.should include(build_router_computer.mac_address)
      @conf_template.render.should include(build_router_computer.ip_address)
      @conf_template.render.should include(build_router_dhcp.gateway)
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
  
  describe 'Iptables config' do
    before :each do
      @conf_template = ConfTemplate.new(
        'iptables.sh', 
        :allow_computers    => [build_router_computer],
        :disabled_computers => [],
        :open_ports => [],
        :iptables   => build_router_service(:bin_path => '/usr/local/sbin/iptables'),
        :extif      => 'eth1',
        :intif      => 'eth0',
        :extip      => '192.168.249.103',
        :intip      => '10.5.5.100',
        :intnet     => '10.0.0.0',
        :connlimit  => '30',
        :grep       => '/usr/bin/grep'
      )
    end

    it "should save rendered file in tmp dir" do
      @conf_template.write
      File.exist?(@conf_template.dest_path).should be_true
      # File.delete(@conf_template.dest_path)
    end
  end
end
