require 'rails_helper'

describe FwRuleContainer do
  before(:each) do
    @filter = { :input => ['f_in'], :forward => ['f_fw'], :output => ['f_out'] }
    @nat = { :prerouting => ['n_pre'], :postrouting => ['n_post'] }
    @mangle = { :input => ['m_in'], :forward => ['m_fw'], :prerouting => ['m_pre'], :postrouting => ['m_post'] }
    data = { :filter => @filter, :nat => @nat, :mangle => @mangle }
    allow(FwRuleContainer).to receive(:rules).and_return(data)
  end

  it "should have ip tables" do
    expect(described_class.ip_tables - [:filter, :nat, :mangle]).to eq []
  end

  it "should have chains for" do
    expect((described_class.chains_for(:filter)-@filter.keys)).to eq []
    expect((described_class.chains_for(:nat)-@nat.keys)).to eq []
    expect((described_class.chains_for(:mangle)-@mangle.keys)).to eq []
  end

  it "should have rules for filter" do
    expect(described_class.rules_for(:filter, :input)).to eq @filter[:input]
    expect(described_class.rules_for(:filter, 'input')).to eq @filter[:input]
    expect(described_class.rules_for(:filter, 'INPUT')).to eq @filter[:input]
    expect(described_class.rules_for(:filter, '').keys).to eq @filter.keys
    expect(described_class.rules_for(:filter).keys).to eq @filter.keys
    expect(described_class.rules_for(:filter, 'xxx').keys).to eq @filter.keys
    expect(described_class.rules_for('').keys).to eq @filter.keys
    expect(described_class.rules_for(nil).keys).to eq @filter.keys
    expect(described_class.rules_for(:ass).keys).to eq @filter.keys
  end

  it "should have rules for nat" do
    expect(described_class.rules_for(:nat).keys).to eq @nat.keys
    expect(described_class.rules_for(:nat, :prerouting)).to eq @nat[:prerouting]
    expect(described_class.rules_for(:nat, :prerouting)).to include(@nat[:prerouting][0])
    expect(described_class.rules_for(:nat, :input).keys).to eq @nat.keys
  end
end
