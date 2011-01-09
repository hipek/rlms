class Dwnl::WebJobsController < ApplicationController
  def index
    @web_jobs = WebJob.find(:all)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @web_job = WebJob.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @web_job = WebJob.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @web_job = WebJob.find(params[:id])
  end

  def create
    @web_job = WebJob.new(params[:web_job])
    @web_job.generate if params[:generate]

    respond_to do |format|
      if params[:generate].nil? && @web_job.save
        @web_job.create_directory
        flash[:notice] = 'WebJob was successfully created.'
        format.html { redirect_to dwnl_web_job_url(@web_job) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @web_job = WebJob.find(params[:id])
    if params[:generate]
      @web_job.attributes = params[:web_job]
      @web_job.generate
    end
    
    respond_to do |format|
      if params[:generate].nil? && @web_job.update_attributes(params[:web_job]) 
        flash[:notice] = 'WebJob was successfully updated.'
        format.html { redirect_to dwnl_web_job_url(@web_job) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @web_job = WebJob.find(params[:id])
    @web_job.destroy

    respond_to do |format|
      format.html { redirect_to(dwnl_web_jobs_url) }
    end
  end
  
  def start
    @web_job = WebJob.find(params[:id]) or return redirect_to(dwnl_web_jobs_path)
    @web_job.write_body
    @web_job.start! if @web_job.pending?
    flash[:notice] = "WebJob was successfully saved in #{@web_job.urls_file_path}."
    redirect_to(dwnl_web_jobs_path)
  end
end
