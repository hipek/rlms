require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FwDnat do
  before(:each) do
    @fw_dnat = FwDnat.new
  end

  it "should be valid" do
    @fw_dnat.should be_valid
  end

  it "should have default values" do
    @fw_dnat.valid?
    @fw_dnat.ip_table.should eql('NAT')
    @fw_dnat.chain_name.should eql('PREROUTING')
    @fw_dnat.target.should eql('DNAT')
    @fw_dnat.dest_ip.should eql('0.0.0.0')
  end
end
