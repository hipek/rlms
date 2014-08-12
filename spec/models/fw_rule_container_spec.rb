require 'spec_helper'

describe FwRuleContainer do
  before(:each) do
    @filter = { :input => ['f_in'], :forward => ['f_fw'], :output => ['f_out'] }
    @nat = { :prerouting => ['n_pre'], :postrouting => ['n_post'] }
    @mangle = { :input => ['m_in'], :forward => ['m_fw'], :prerouting => ['m_pre'], :postrouting => ['m_post'] }
    data = { :filter => @filter, :nat => @nat, :mangle => @mangle }
    allow(FwRuleContainer).to receive(:rules).and_return(data)
  end
  
  it "should have ip tables" do
    (described_class.ip_tables - [:filter, :nat, :mangle]).should == []
  end
  
  it "should have chains for" do
    (described_class.chains_for(:filter)-@filter.keys).should == []
    (described_class.chains_for(:nat)-@nat.keys).should == []
    (described_class.chains_for(:mangle)-@mangle.keys).should == []
  end
  
  it "should have rules for filter" do
    described_class.rules_for(:filter, :input).should == @filter[:input]
    described_class.rules_for(:filter, 'input').should == @filter[:input]
    described_class.rules_for(:filter, 'INPUT').should == @filter[:input]
    described_class.rules_for(:filter, '').keys.should == @filter.keys
    described_class.rules_for(:filter).keys.should == @filter.keys
    described_class.rules_for(:filter, 'xxx').keys.should == @filter.keys
    described_class.rules_for('').keys.should == @filter.keys
    described_class.rules_for(nil).keys.should == @filter.keys
    described_class.rules_for(:ass).keys.should == @filter.keys
  end
  
  it "should have rules for nat" do
    described_class.rules_for(:nat).keys.should == @nat.keys
    described_class.rules_for(:nat, :prerouting).should == @nat[:prerouting]
    described_class.rules_for(:nat, :prerouting).should  include(@nat[:prerouting][0])
    described_class.rules_for(:nat, :input).keys.should == @nat.keys
  end
end
