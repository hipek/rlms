require 'spec_helper'

describe Router::TcClassidsController do
  fixtures :users
  render_views

  def mock_tc_classid(stubs={})
    @mock_tc_classid ||= mock_model(Router::Tc::Classid, stubs).as_null_object
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
      Router::Tc::Classid.stub(:find).with("37") { mock_tc_classid }
      get :edit, :id => "37"
      assigns(:tc_classid).should be(mock_tc_classid)
      response.should be_success
    end
  end
end
