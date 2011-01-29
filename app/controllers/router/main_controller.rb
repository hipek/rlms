class Router::MainController < Router::BaseController
  def index
    @router_main = Router::Main.instance
  end

  def update
    @router_main = Router::Main.instance
    if @router_main.update_attributes params[:router_main]
      redirect_to(router_main_path, :notice => 'Setting updated successfully.')
    else

    end
  end
end
