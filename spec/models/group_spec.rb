require File.dirname(__FILE__) + '/../spec_helper'

describe "Group" do

  describe "validations" do
    before(:each) do
      @group = Group.new(:name => "Hunters")
    end

    it "should be valid" do
      @group.should be_valid
    end

    it "should have a unique name" do
      @group.save
      @group2 = Group.new(:name => "Hunters")
      @group2.should_not be_valid
    end
  end

  describe "associations" do
    fixtures :groups, :group_memberships

    it "should get groups correctly" do
      groups(:publishers).groups.size.should == 2
      arr = []
      arr << groups(:customers)
      arr << groups(:company)
      groups(:publishers).groups.should == arr

      groups(:admins).groups.size.should == 1
      arr = []
      arr << groups(:company)
      groups(:admins).groups.should == arr
    end
  end
end
