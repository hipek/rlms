require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FwRule do
  fixtures :fw_rules

  before(:each) do
    @fw_rule = FwRule.new
  end

  it "should be valid" do
    @fw_rule.should be_valid
  end

  it "should have blocked ips" do
    FwRuleContainer.stub!(:rules_for).and_return([FwRule.new(:chain_name => 'PREROUTING', :src_ip => "10.5.5.5"), FwRule.new(:chain_name => 'PREROUTING', :src_ip => nil),])
    FwRule.blocked_ips.should include("10.5.5.5")
  end
end
