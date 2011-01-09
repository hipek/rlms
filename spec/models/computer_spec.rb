require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Computer do
  before(:each) do
    @computer = build_computer
  end

  it "should validate mac address entry" do
    @computer = build_computer :mac_address => "10-12;13:af.dc,ag"
    @computer.should_not be_valid
  end

  it "should be valid" do
    @computer.should be_valid
  end
  
  it "should save valid mac address" do
    @computer = build_computer :mac_address => "10-12;13:af.dc,ab"
    @computer.save!
    @computer.mac_address.should == "10:12:13:AF:DC:AB"
  end

  it "should have name without spaces" do
    @computer.valid_name.should == 'it_a_cool_bame'
  end
  
  it "should return next free IP" do
    @computer.ip_address = "10.5.5.21"
    @computer.save!
    @computer2 = build_computer :ip_address => "10.5.5.15", :mac_address => "10:12:13:14:15:16"
    @computer2.save!
    Computer.next_ip.should == "10.5.5.22"
  end
end
