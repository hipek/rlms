require 'rails_helper'

describe FwRule do
  fixtures :fw_rules

  it "should be valid" do
    is_expected.to be_valid
  end

  it "should have blocked ips" do
    allow(FwRuleContainer).to receive(:rules_for).and_return([described_class.new(:chain_name => 'PREROUTING', :src_ip => "10.5.5.5"), described_class.new(:chain_name => 'PREROUTING', :src_ip => nil),])
    expect(described_class.blocked_ips).to include("10.5.5.5")
  end
end
