class Router::ServicesController < Router::BaseController
  def index
  end

  def update
    redirect_to(router_services_url)
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

end
