class Router::ServicesController < Router::BaseController
  def index
  end

  def update
    redirect_to(router_services_url)
  end

end
