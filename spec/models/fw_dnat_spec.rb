require 'rails_helper'

describe FwDnat do
  before(:each) do
    @fw_dnat = FwDnat.new
  end

  it "should be valid" do
    expect(@fw_dnat).to be_valid
  end

  it "should have default values" do
    @fw_dnat.valid?
    expect(@fw_dnat.ip_table).to eql('NAT')
    expect(@fw_dnat.chain_name).to eql('PREROUTING')
    expect(@fw_dnat.target).to eql('DNAT')
    expect(@fw_dnat.dest_ip).to eql('0.0.0.0')
  end
end
