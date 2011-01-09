require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/dwnl_web_jobs/show.html.erb" do
  include Dwnl::WebJobsHelper
  
  before(:each) do
    @web_job = mock_model(WebJob)
    @web_job.stub!(:name).and_return("MyString")
    @web_job.stub!(:state).and_return("MyString")
    @web_job.stub!(:body).and_return("MyText")
    @web_job.stub!(:started_at).and_return(Time.now)
    @web_job.stub!(:ended_at).and_return(Time.now)

    assigns[:web_job] = @web_job
  end

  it "should render attributes in <p>" do
    render "/dwnl/web_jobs/show.html.erb"
    response.capture(:col2).should have_text(/MyString/)
    response.capture(:col2).should have_text(/MyString/)
    response.capture(:col2).should have_text(/MyText/)
  end
end

