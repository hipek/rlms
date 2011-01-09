require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/firewalls/edit.html.erb" do
  include FirewallsHelper
  
  before do
    @firewall = mock_model(Firewall)
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

  it "should render edit form" do
    render "/firewalls/edit.html.erb"
    
    response.capture(:col2).should have_tag("form[action=#{firewall_path(@firewall)}][method=post]") do
      with_tag('input#firewall_name[name=?]', "firewall[name]")
      with_tag('input#firewall_visibility[name=?]', "firewall[visibility]")
    end
  end
end


