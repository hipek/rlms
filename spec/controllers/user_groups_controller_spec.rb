require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserGroupsController do
  fixtures :users, :groups, :group_memberships
  render_views

  before(:each) do
    login_as(:admin)
    add_permission groups(:administrator), "admin"
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end
end
