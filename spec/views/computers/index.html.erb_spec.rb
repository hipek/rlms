require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/computers/index.html.erb" do
  fixtures :users, :groups, :group_memberships
  include ComputersHelper

  before(:each) do
    stub_current_user users(:admin)
    stub_shell_commands
    computer_98 = build_computer
    computer_98.stub!(:id).and_return(98)
    computer_99 = build_computer
    computer_99.stub!(:id).and_return(99)

    assigns[:computers] = [computer_98, computer_99]
    assigns[:online_computers] = [computer_98, computer_99]
    assigns[:online_ips] = []
    assigns[:blocked_ips] = []
  end

  it "should render list of computers" do
    render "/computers/index.html.erb"
    response.capture(:col2).should_not be_nil
  end
end
