require 'rails_helper'

describe "Group" do

  describe "validations" do
    before(:each) do
      @group = Group.new(:name => "Hunters")
    end

    it "should be valid" do
      expect(@group).to be_valid
    end

    it "should have a unique name" do
      @group.save
      @group2 = Group.new(:name => "Hunters")
      expect(@group2).to_not be_valid
    end
  end

  describe "associations" do
    fixtures :groups, :group_memberships

    it "should get groups correctly" do
      expect(groups(:publishers).groups.size).to eq 2
      arr = []
      arr << groups(:customers)
      arr << groups(:company)
      expect(groups(:publishers).groups).to eq arr

      expect(groups(:admins).groups.size).to eq 1
      arr = []
      arr << groups(:company)
      expect(groups(:admins).groups).to eq arr
    end
  end
end
