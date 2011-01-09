require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/services/edit.html.erb" do
  include ServicesHelper
  
  before do
    @service = mock_model(Service)
    @service.stub!(:name).and_return("MyString")
    @service.stub!(:init_path).and_return("MyString")
    @service.stub!(:config_path).and_return("MyString")
    @service.stub!(:visibility).and_return("1")
    @service.stub!(:status).and_return("1")
    @service.stub!(:bin_path).and_return("1")
    assigns[:service] = @service
  end

  it "should render edit form" do
    render "/services/edit.html.erb"
    
    response.capture(:col2).should have_tag("form[action=#{service_path(@service)}][method=post]") do
      with_tag('input#service_name[name=?]', "service[name]")
      with_tag('input#service_init_path[name=?]', "service[init_path]")
      with_tag('input#service_config_path[name=?]', "service[config_path]")
    end
  end
end


