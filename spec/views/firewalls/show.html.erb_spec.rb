require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/firewalls/show.html.erb" do
  include FirewallsHelper
  
  before(:each) do
    @firewall = mock_model(Firewall)
    @firewall.stub!(:name).and_return("MyString")
    @firewall.stub!(:visibility).and_return("1")
    @firewall.stub!(:start_date).and_return(Time.now)
    @firewall.stub!(:end_date).and_return(Time.now)

    assigns[:firewall] = @firewall
  end

  it "should render attributes in <p>" do
    render "/firewalls/show.html.erb"
    response.capture(:col2).should have_text(/MyString/)
    response.capture(:col2).should have_text(/1/)
  end
end

