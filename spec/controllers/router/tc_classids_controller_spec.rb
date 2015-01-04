require 'rails_helper'

describe Router::TcClassidsController do
  fixtures :users
  render_views

  let(:tc_classid) do
    build :router_tc_classid, id: 1
  end

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

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      expect(Router::Tc::Classid).to receive(:find).with("37") { tc_classid }
      get :edit, :id => "37"
      assigns(:tc_classid).should be(tc_classid)
      response.should be_success
    end
  end
end
