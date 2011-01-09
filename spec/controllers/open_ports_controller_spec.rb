require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe OpenPortsController do
  fixtures :users

  before(:each) do
    login_as(:quentin)
    stub_shell_commands
  end

  describe "GET 'index'" do
    it "should be successful" do
      FwRuleContainer.stub!(:in_open_ports).and_return([FwRule.new])
      get 'index'
      response.should be_success
    end
  end
end
