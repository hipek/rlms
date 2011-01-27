class Router::ServicesController < Router::BaseController
  def index
  end

  def update
    success = true
    Router::Service::Base.all.each do |service|
      success &&= service.update_attributes(params[service.name.downcase.to_sym] || {})
    end
    flash[:notice] = 'Services have been updated.' if success
    redirect_to(router_services_url)
  end

  def find
    results = [""]
    Router::Service::Base::KINDS[params[:id].to_sym].to_a.each do |t|
      results << ShellCommand.find_file(params[:file]+'*', t).split(/\n/)
    end
    @results = results.flatten
    render :partial => 'select_field'
  end

end
