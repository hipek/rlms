require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/dwnl_web_jobs/edit.html.erb" do
  include Dwnl::WebJobsHelper
  
  before do
    @web_job = WebJob.new
    @web_job.stub!(:name).and_return("MyString")
    @web_job.stub!(:state).and_return("MyString")
    @web_job.stub!(:body).and_return("MyText")
    @web_job.stub!(:started_at).and_return(Time.now)
    @web_job.stub!(:ended_at).and_return(Time.now)
    @web_job.stub!(:id).and_return(111)
    assigns[:web_job] = @web_job
  end

  it "should render edit form" do
    render "/dwnl/web_jobs/edit.html.erb"
    
    response.capture(:col2).should have_tag("form[action=#{dwnl_web_job_path(@web_job)}][method=post]") do
      with_tag('input#web_job_name[name=?]', "web_job[name]")
      with_tag('textarea#web_job_body[name=?]', "web_job[body]")
    end
  end
end


