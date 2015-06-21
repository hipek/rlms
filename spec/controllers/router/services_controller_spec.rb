require 'rails_helper'

describe Router::ServicesController do
  fixtures :users
  render_views

  before(:each) do
    login_as(:quentin)
    stub_shell_commands
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      expect(response).to be_success
    end
  end

  describe "PUT 'update'" do
    it "should redirected to router_services_url" do
      put :update, :id => 0
      expect(response).to redirect_to(router_services_url)
    end
  end

end
