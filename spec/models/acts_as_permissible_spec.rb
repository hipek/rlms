require 'rails_helper'

Permission.send :acts_as_permissible

describe "acts_as_permissible" do
  fixtures :permissions

  before(:each) do
    @perm = permissions(:perm)
  end

  describe "class methods" do
    it "should find_permissions_for(obj) correctly" do
      expect(Permission.find_permissions_for(@perm).size).to eql(2)
      expect(Permission.find_permissions_for(@perm).first.action).to eql("view_something")
      expect(Permission.find_permissions_for(@perm).last.action).to eql("delete_something")
    end
  end

  describe "permissions_hash" do
    it "should return the correct permissions_hash" do
      expect(@perm.permissions_hash).to eql({:view_something => true, :delete_something => false})
    end
  end

  describe "has_permission?" do
    it "should return true if permission found" do
      expect(@perm.has_permission?("view_something")).to eql(true)
    end

    it "should return false if permission not found" do
      expect(@perm.has_permission?("create_something")).to eql(false)
    end

    it "should return false if permission found and is denied" do
      expect(@perm.has_permission?("delete_something")).to eql(false)
    end
  end

  describe "merge_permissions!" do
    before(:each) do
      @perm2 = permissions(:perm2)
      @merged_permissions = @perm.merge_permissions!(@perm2.permissions_hash)
      # {:update_something=>true, :view_something=>true, :delete_something=>false, :create_something=>false}
    end

    it "should include all keys from both hashes" do
      expect(@merged_permissions.keys).to eql(
        (@perm.permissions_hash.keys + @perm2.permissions_hash.keys).uniq
      )
    end

    it "should override identical keys with false value" do
      expect(@merged_permissions[:delete_something]).to eql(false)
    end
  end

  describe "reload_permissions!" do
    before(:each) do
      @original_hash = @perm.permissions_hash
      @perm.permissions << Permission.new(:action => "add_something", :granted => true)
    end

    it "should catch-up with database changes" do
      expect(@perm.permissions_hash).to eql(@original_hash)
      reloaded_hash = @perm.reload_permissions!
      expect(reloaded_hash).to_not eq @original_hash
    end

    it "should get the changes correctly" do
      reloaded_hash = @perm.reload_permissions!
      expect(reloaded_hash.keys).to include(:add_something)
    end
  end

  describe "groups_list" do
    before(:each) do
      expect(@perm.groups_list).to eql([])
      @mutables = Group.new(:name => "mutables")
      @mutables.save!
      @wierdos = Group.new(:name => "wierdos")
      @wierdos.save!
      @mutables.groups << @wierdos
    end

    after(:each) do
      @mutables.destroy
      @wierdos.destroy
      @perm.groups.reset
      expect(@perm.reload.groups_list).to eql([])
    end

    it "should return the correct list" do
      @perm.groups << @wierdos
      expect(@perm.groups_list.size).to eql(1)
      expect(@perm.groups_list).to include("wierdos")
    end

    it "should return the correct list including parent groups of groups recursively." do
      @perm.groups << @mutables
      expect(@perm.groups_list.size).to eql(2)
      expect(@perm.groups_list).to include("mutables")
      expect(@perm.groups_list).to include("wierdos")
    end
  end

  describe "in_group?" do
    before(:each) do
      @mutables = Group.new(:name => "mutables")
      @mutables.save!
      @immutables = Group.new(:name => "immutables")
      @immutables.save!
    end

    after(:each) do
      @mutables.destroy
      @immutables.destroy
      @perm.groups.reset
    end

    it "should return true if member of one" do
      @perm.groups << @mutables
      expect(@perm.in_group?("mutables")).to eql(true)
    end

    it "should return false if not a member" do
      expect(@perm.in_group?("mutables")).to eql(false)
    end

    it "should return true if member of all" do
      @perm.groups << @mutables
      @perm.groups << @immutables
      expect(@perm.in_group?("mutables","immutables")).to eql(true)
    end

    it "should return false if member of some" do
      @perm.groups << @mutables
      expect(@perm.in_group?("mutables","immutables")).to eql(false)
    end
  end

  describe "in_any_group?" do
    before(:each) do
      @mutables = Group.new(:name => "mutables")
      @mutables.save!
      @immutables = Group.new(:name => "immutables")
      @immutables.save!
    end

    it "should return true if member of one" do
      @perm.groups << @mutables
      expect(@perm.in_any_group?("mutables","immutables")).to eql(true)
    end

    it "should return false if not a member" do
      expect(@perm.in_any_group?("mutables","immutables")).to eql(false)
    end

    it "should return true if member of all" do
      @perm.groups << @mutables
      @perm.groups << @immutables
      expect(@perm.in_any_group?("mutables","immutables")).to eql(true)
    end
  end

  describe "full_permissions_hash" do
    before(:each) do
      @mutables = Group.new(:name => "mutables")
      @mutables.save!
      @mutable_permission = Permission.new(:permissible_id => @mutables.id, :permissible_type => @mutables.class.to_s, :action => "view_something", :granted => false)
      @mutable_permission.save!
      @immutables = Group.new(:name => "immutables")
      @immutables.save!
      @immutable_permission = Permission.new(:permissible_id => @immutables.id, :permissible_type => @immutables.class.to_s, :action => "download_something", :granted => true)
      @immutable_permission.save!
    end

    it "should return the correct hash if object doesn't belong to groups" do
      expect(@perm.groups).to be_empty
      expect(@perm.full_permissions_hash).to eql({:view_something=>true, :delete_something=>false})
    end

    it "should return the correct hash if object belongs to one group" do
      @perm.groups << @mutables
      expect(@perm.full_permissions_hash).to eql({:view_something=>false, :delete_something=>false})
    end

    it "should return the correct hash if object belongs to one group which belongs to another group" do
      @mutables.groups << @immutables
      @perm.groups << @mutables
      expect(@perm.full_permissions_hash).to eql({:view_something=>false, :delete_something=>false, :download_something=>true})
    end

    it "should return the correct hash if object belongs to 2 groups" do
      @perm.groups << @immutables
      @perm.groups << @mutables
      expect(@perm.full_permissions_hash).to eql({:view_something=>false, :delete_something=>false, :download_something=>true})
    end

    after(:each) do
      @mutables.destroy
      @immutables.destroy
      @perm.groups.reset
    end
  end

end
