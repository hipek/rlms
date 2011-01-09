require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/dwnl_web_jobs/new.html.erb" do
  include Dwnl::WebJobsHelper
  
  before(:each) do
    @web_job = WebJob.new
    @web_job.stub!(:new_record?).and_return(true)
    @web_job.stub!(:name).and_return("MyString")
    @web_job.stub!(:state).and_return("MyString")
    @web_job.stub!(:body).and_return("MyText")
    @web_job.stub!(:started_at).and_return(Time.now)
    @web_job.stub!(:ended_at).and_return(Time.now)
    assigns[:web_job] = @web_job
  end

  it "should render new form" do
    render "/dwnl/web_jobs/new.html.erb"
    
    response.capture(:col2).should have_tag("form[action=?][method=post]", dwnl_web_jobs_path) do
      with_tag("input#web_job_name[name=?]", "web_job[name]")
      with_tag("textarea#web_job_body[name=?]", "web_job[body]")
    end
  end
end


