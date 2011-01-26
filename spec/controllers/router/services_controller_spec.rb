require 'spec_helper'

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
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    it "should be successful" do
      put :update, :id => 0
      response.should redirect_to(router_services_url)
    end
  end

end
