require 'rails_helper'

describe Router::MainController do
  fixtures :users
  render_views

  before(:each) do
    login_as(:quentin)
    stub_shell_commands
  end

  describe "GET 'index'" do
    it "should be successful" do
      get :index
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    it "should be successful" do
      put :update, :router_main => {
        dns_server1: '194.204.159.1',
        interfaces_attributes: [{name: 'eth0'}]
      }
      response.should redirect_to(router_main_url)
    end
  end
end
