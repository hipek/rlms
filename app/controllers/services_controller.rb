class ServicesController < ApplicationController
  def index
    @services = Service.find(:all)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def find
    types = {
      :config => '/etc', 
      :init => '/etc/init.d', 
      :bin => ['/sbin', '/bin', '/usr/sbin', '/usr/bin', '/usr/local/bin', '/usr/local/sbin']
    }
    results = [""]
    types[params[:id].to_sym].to_a.each do |t|
      results << ShellCommand.find_file(params[:file]+'*', t).split(/\n/)
    end
    @results = results.flatten
    render :partial => 'select_field'
  end
  
  def show
    @service = Service.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @service = Service.new :status => RUNNING, :visibility => ACTIVE

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @service = Service.find(params[:id])
  end

  def create
    @service = Service.new(params[:service])

    respond_to do |format|
      if @service.save
        flash[:notice] = 'Service was successfully created.'
        format.html { redirect_to(services_path) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @service = Service.find(params[:id])

    respond_to do |format|
      if @service.update_attributes(params[:service])
        flash[:notice] = 'Service was successfully updated.'
        format.html { redirect_to(services_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @service = Service.find(params[:id])
    @service.destroy

    respond_to do |format|
      format.html { redirect_to(services_url) }
    end
  end
end
