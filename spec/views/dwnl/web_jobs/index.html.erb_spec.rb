require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/dwnl_web_jobs/index.html.erb" do
  include Dwnl::WebJobsHelper
  
  before(:each) do
    web_job_98 = mock_model(WebJob)
    web_job_98.should_receive(:name).and_return("MyString")
    web_job_98.should_receive(:state).and_return("MyString")
    web_job_98.should_receive(:body).and_return("MyText")
    web_job_98.should_receive(:started_at).and_return(Time.now)
    web_job_98.should_receive(:ended_at).and_return(Time.now)
    web_job_98.should_receive(:pending?).and_return(true)
    web_job_99 = mock_model(WebJob)
    web_job_99.should_receive(:name).and_return("MyString")
    web_job_99.should_receive(:state).and_return("MyString")
    web_job_99.should_receive(:body).and_return("MyText")
    web_job_99.should_receive(:started_at).and_return(Time.now)
    web_job_99.should_receive(:ended_at).and_return(Time.now)
    web_job_99.should_receive(:pending?).and_return(true)

    assigns[:web_jobs] = [web_job_98, web_job_99]
  end

  it "should render list of dwnl_web_jobs" do
    render "/dwnl/web_jobs/index.html.erb"
    response.capture(:col2).should have_tag("tr>td", "MyString", 2)
    response.capture(:col2).should have_tag("tr>td", "MyString", 2)
    response.capture(:col2).should have_tag("tr>td", "MyText", 2)
  end
end

