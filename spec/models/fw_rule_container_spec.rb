require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FwRuleContainer do
  before(:each) do
    @filter = { :input => ['f_in'], :forward => ['f_fw'], :output => ['f_out'] }
    @nat = { :prerouting => ['n_pre'], :postrouting => ['n_post'] }
    @mangle = { :input => ['m_in'], :forward => ['m_fw'], :prerouting => ['m_pre'], :postrouting => ['m_post'] }
    data = { :filter => @filter, :nat => @nat, :mangle => @mangle }
    FwRuleContainer.stub!(:rules).and_return(data)
  end
  
  it "should have ip tables" do
    (FwRuleContainer.ip_tables - [:filter, :nat, :mangle]).should == []
  end
  
  it "should have chains for" do
    (FwRuleContainer.chains_for(:filter)-@filter.keys).should == []
    (FwRuleContainer.chains_for(:nat)-@nat.keys).should == []
    (FwRuleContainer.chains_for(:mangle)-@mangle.keys).should == []
  end
  
  it "should have rules for filter" do
    FwRuleContainer.rules_for(:filter, :input).should == @filter[:input]
    FwRuleContainer.rules_for(:filter, 'input').should == @filter[:input]
    FwRuleContainer.rules_for(:filter, 'INPUT').should == @filter[:input]
    FwRuleContainer.rules_for(:filter, '').keys.should == @filter.keys
    FwRuleContainer.rules_for(:filter).keys.should == @filter.keys
    FwRuleContainer.rules_for(:filter, 'xxx').keys.should == @filter.keys
    FwRuleContainer.rules_for('').keys.should == @filter.keys
    FwRuleContainer.rules_for(nil).keys.should == @filter.keys
    FwRuleContainer.rules_for(:ass).keys.should == @filter.keys
  end
  
  it "should have rules for nat" do
    FwRuleContainer.rules_for(:nat).keys.should == @nat.keys
    FwRuleContainer.rules_for(:nat, :prerouting).should == @nat[:prerouting]
    FwRuleContainer.rules_for(:nat, :prerouting).should  include(@nat[:prerouting][0])
    FwRuleContainer.rules_for(:nat, :input).keys.should == @nat.keys
  end
end
