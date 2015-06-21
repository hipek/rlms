require 'rails_helper'

describe Router::DhcpsController do
  fixtures :users
  render_views

  before(:each) do
    login_as(:quentin)
    stub_shell_commands
    allow(Router::Dhcp).to receive(:first).and_return(build_router_dhcp)
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
      expect(response).to redirect_to(router_dhcps_url)
    end
  end
end
