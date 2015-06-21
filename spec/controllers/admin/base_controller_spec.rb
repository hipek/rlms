require 'rails_helper'

describe Admin::BaseController do
  fixtures :users, :groups, :group_memberships
  render_views

  before(:each) do
    login_as(:admin)
    add_permission groups(:administrator), "admin"
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      expect(response).to be_success
    end
  end

end
