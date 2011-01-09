require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/computers/edit.html.erb" do
  include ComputersHelper

  before do
    @computer = mock_model(Computer)
    @computer.stub!(:name).and_return("MyString")
    @computer.stub!(:mac_address).and_return("MyString")
    @computer.stub!(:ip_address).and_return("MyString")
    assigns[:computer] = @computer
    @controller.template.stub!(:current_user).and_return(mock_model(User, :has_permission? => true))
  end

  it "should render edit form" do
    render "/computers/edit.html.erb"

    response.capture(:col2).should have_tag("form[action=#{computer_path(@computer)}][method=post]") do
      with_tag('input#computer_name[name=?]', "computer[name]")
      with_tag('input#computer_mac_address[name=?]', "computer[mac_address]")
    end
  end
end


