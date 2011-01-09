require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/computers/show.html.erb" do
  fixtures :users, :groups, :group_memberships
  include ComputersHelper

  before(:each) do
    stub_current_user users(:admin)
    @computer = mock_model(Computer)
    @computer.stub!(:name).and_return("MyString")
    @computer.stub!(:mac_address).and_return("MyString")
    @computer.stub!(:ip_address).and_return("MyString")

    assigns[:computer] = @computer
  end

  it "should render attributes" do
    render "/computers/show.html.erb"
    response.capture(:col2).should have_text(/MyString/)
    response.capture(:col2).should have_text(/MyString/)
  end
end

