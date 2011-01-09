require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/firewalls/new.html.erb" do
  include FirewallsHelper
  
  before(:each) do
    @firewall = mock_model(Firewall)
    @firewall.stub!(:new_record?).and_return(true)
    @firewall.stub!(:name).and_return("MyString")
    @firewall.stub!(:visibility).and_return("1")
    @firewall.stub!(:start_date).and_return(Time.now)
    @firewall.stub!(:end_date).and_return(Time.now)
    @firewall.stub!(:ext_inf).and_return('eth0')
    @firewall.stub!(:ext_ip).and_return('10.5.5.10')
    @firewall.stub!(:auto_ext_ip).and_return('10.5.5.10')
    @firewall.stub!(:int_inf).and_return('eth0')
    @firewall.stub!(:int_ip).and_return('10.5.5.10')
    @firewall.stub!(:auto_int_ip).and_return('10.5.5.10')
    assigns[:firewall] = @firewall
  end

  it "should render new form" do
    render "/firewalls/new.html.erb"
    
    response.capture(:col2).should have_tag("form[action=?][method=post]", firewalls_path) do
      with_tag("input#firewall_name[name=?]", "firewall[name]")
      with_tag("input#firewall_visibility[name=?]", "firewall[visibility]")
    end
  end
end


