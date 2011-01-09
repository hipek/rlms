require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/services/show.html.erb" do
  include ServicesHelper
  
  before(:each) do
    @service = mock_model(Service)
    @service.stub!(:name).and_return("MyString")
    @service.stub!(:init_path).and_return("MyString")
    @service.stub!(:config_path).and_return("MyString")
    @service.stub!(:bin_path).and_return("MyString")
    @service.stub!(:visibility).and_return("1")
    @service.stub!(:status).and_return("1")

    assigns[:service] = @service
  end

  it "should render attributes in <p>" do
    render "/services/show.html.erb"
    response.capture(:col2).should have_text(/MyString/)
    response.capture(:col2).should have_text(/MyString/)
    response.capture(:col2).should have_text(/MyString/)
    response.capture(:col2).should have_text(/1/)
    response.capture(:col2).should have_text(/1/)
  end
end

