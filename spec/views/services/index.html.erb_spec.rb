require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/services/index.html.erb" do
  include ServicesHelper
  
  before(:each) do
    service_98 = mock_model(Service)
    service_98.should_receive(:name).and_return("MyString")
    service_98.should_receive(:init_path).and_return("MyString")
    service_98.should_receive(:config_path).and_return("MyString")
    service_98.should_receive(:bin_path).and_return("MyString")
    service_99 = mock_model(Service)
    service_99.should_receive(:name).and_return("MyString")
    service_99.should_receive(:init_path).and_return("MyString")
    service_99.should_receive(:config_path).and_return("MyString")
    service_99.should_receive(:bin_path).and_return("MyString")
    assigns[:services] = [service_98, service_99]
  end

  it "should render list of services" do
    render "/services/index.html.erb"
    response.capture(:col2).should have_tag("tr>td", "MyString", 2)
    response.capture(:col2).should have_tag("tr>td", "MyString", 2)
    response.capture(:col2).should have_tag("tr>td", "MyString", 2)
  end
end

