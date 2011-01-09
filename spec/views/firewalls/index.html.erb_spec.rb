require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/firewalls/index.html.erb" do
  include FirewallsHelper
  
  before(:each) do
    firewall_98 = mock_model(Firewall)
    firewall_98.should_receive(:name).and_return("MyString")
    firewall_98.should_receive(:start_date).and_return(Time.now)
    firewall_98.should_receive(:end_date).and_return(Time.now)
    firewall_99 = mock_model(Firewall)
    firewall_99.should_receive(:name).and_return("MyString")
    firewall_99.should_receive(:start_date).and_return(Time.now)
    firewall_99.should_receive(:end_date).and_return(Time.now)

    assigns[:firewalls] = [firewall_98, firewall_99]
  end

  it "should render list of firewalls" do
    render "/firewalls/index.html.erb"
    response.capture(:col2).should have_tag("tr>td", "MyString", 2)
  end
end

