require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/computers/new.html.erb" do
  include ComputersHelper

  before(:each) do
    @computer = mock_model(Computer)
    @computer.stub!(:new_record?).and_return(true)
    @computer.stub!(:name).and_return("MyString")
    @computer.stub!(:mac_address).and_return("MyString")
    @computer.stub!(:ip_address).and_return("MyString")
    assigns[:computer] = @computer
    @controller.template.stub!(:current_user).and_return(mock_model(User, :has_permission? => true))
  end

  it "should render new form" do
    render "/computers/new.html.erb"

    response.capture(:col2).should have_tag("form[action=?][method=post]", computers_path) do
      with_tag("input#computer_name[name=?]", "computer[name]")
      with_tag("input#computer_mac_address[name=?]", "computer[mac_address]")
    end
  end
end


