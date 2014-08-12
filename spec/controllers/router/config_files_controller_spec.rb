require 'spec_helper'

describe Router::ConfigFilesController do
  fixtures :users
  render_views

  before(:each) do
    login_as(:quentin)
    stub_shell_commands
  end

  describe "GET 'dhcp'" do
    it "should be successful" do
      allow(Router::Dhcp).to receive(:instance).and_return(build_router_dhcp)
      get 'dhcp'
      response.should be_success
    end
  end

  describe "GET 'iptables'" do
    it "should be successful" do
      allow(Router::Main).to receive(:instance).and_return(build_router_main)
      get 'iptables'
      response.should be_success
    end
  end

end
