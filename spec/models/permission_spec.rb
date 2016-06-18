require 'rails_helper'

describe Permission, "to_hash" do
  before(:each) do
    @permission = Permission.new(:permissible_id => 1, :permissible_type => "User", :action => "some_action", :granted => 1)
  end

  it "to_hash returns {} if new record" do
    expect(@permission.to_hash).to eq({})
  end

  it "to_hash returns {action => granted}" do
    @permission.save
    expect(@permission.to_hash).to eq({"some_action" => true})
  end

end

describe Permission, "validations" do
  before(:each) do
    @permission = Permission.new(:permissible_id => 1, :permissible_type => "User", :action => "some_action", :granted => 1)
  end

  it "should be valid" do
    expect(@permission).to be_valid
  end

  it "action should be unique to a permissible id and type" do
    @permission.save
    @permission2 = Permission.new(:permissible_id => 1, :permissible_type => "User", :action => "some_action", :granted => 0)
    expect(@permission2).to_not be_valid
  end

  it "must have a permissible_id" do
    @permission.permissible_id = nil
    expect(@permission).to_not be_valid
  end

  it "must have a permissible_type" do
    @permission.permissible_type = nil
    expect(@permission).to_not be_valid
  end

  it "must have an action" do
    @permission.action = nil
    expect(@permission).to_not be_valid
    @permission.action = ""
    expect(@permission).to_not be_valid
  end

end
