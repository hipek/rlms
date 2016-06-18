require 'rails_helper'

describe "GroupMembership" do

  describe "validations" do
    before(:all) do
      @groups = []
      @groups[0] = Group.new(:name => "group0")
      @groups[1] = Group.new(:name => "group1")
      @groups[2] = Group.new(:name => "group2")
      @groups[3] = Group.new(:name => "group3")
      @groups[4] = Group.new(:name => "group4")
      @groups[5] = Group.new(:name => "group5")
      @groups[6] = Group.new(:name => "group6")
      @groups[7] = Group.new(:name => "group7")
      @groups[8] = Group.new(:name => "group8")
      @groups[9] = Group.new(:name => "group9")
      @groups[10] = Group.new(:name => "group10")
      @groups[11] = Group.new(:name => "group11")
      @groups.each {|group| group.save!}
    end

    before(:each) do
      @membership = GroupMembership.new(:roleable_id => @groups[0].id, :roleable_type => "Group", :group_id => @groups[1].id)
    end

    it "should be valid" do
      expect(@membership).to be_valid
    end

    # roleable_id
    it "should have a roleable_id" do
      @membership.roleable_id = nil
      expect(@membership).to_not be_valid
    end

    it "roleable_id should be an integer" do
      @membership.roleable_id = "asd"
      expect(@membership).to_not be_valid
    end

    # roleable_type
    it "should have a roleable_type" do
      @membership.roleable_type = nil
      expect(@membership).to_not be_valid
    end

    it "roleable_type should be a string" do
      @membership.roleable_type = 123
      expect(@membership).to_not be_valid
    end

    it "roleable_type should have a class name format" do
      @membership.roleable_type = "asd"
      expect(@membership).to_not be_valid
      @membership.roleable_type = "User"
      expect(@membership).to be_valid
      @membership.roleable_type = "Some95WierdClassN4m3"
      expect(@membership).to be_valid
    end

    # group_id
    it "should have a group_id" do
      @membership.group_id = nil
      expect(@membership).to_not be_valid
    end

    it "group_id should be an integer" do
      @membership.group_id = "asd"
      expect(@membership).to_not be_valid
    end

    it "should not allow a group to belong to itself" do
      @membership.group_id = @groups[0].id
      expect(@membership).to_not be_valid
    end

    # groups cannot belong to each other in a loop
    it "should not a allow a group to belong to a group which belongs to it in a loop" do
      @groups[0].groups << @groups[1]
      @groups[1].groups << @groups[2]
      @groups[2].groups << @groups[3]
      @groups[2].groups << @groups[4]
      @groups[2].groups << @groups[5]
      @groups[3].groups << @groups[6]
      @groups[1].groups << @groups[7]
      @groups[3].groups << @groups[8]
      @groups[4].groups << @groups[9]
      @groups[4].groups << @groups[10]
      @groups[5].groups << @groups[11]
      @membership3 = GroupMembership.new(:roleable_id => @groups[11].id, :roleable_type => "Group", :group_id => @groups[0].id)
      expect(@membership3).to_not be_valid
      expect(@membership3.errors.full_messages).to include("A group cannot belong to a group which belongs to it.")
    end

    after(:all) do
      @groups.each {|group| group.destroy}
    end
  end
end
