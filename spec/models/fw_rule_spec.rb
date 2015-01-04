require 'rails_helper'

describe FwRule do
  fixtures :fw_rules

  before(:each) do
    @fw_rule = described_class.new
  end

  it "should be valid" do
    @fw_rule.should be_valid
  end

  it "should have blocked ips" do
    allow(FwRuleContainer).to receive(:rules_for).and_return([described_class.new(:chain_name => 'PREROUTING', :src_ip => "10.5.5.5"), described_class.new(:chain_name => 'PREROUTING', :src_ip => nil),])
    described_class.blocked_ips.should include("10.5.5.5")
  end
end
