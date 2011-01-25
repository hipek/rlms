class Router::OpenPortsController < Router::BaseController
  def index
    @open_ports = Router::Rule::OpenPort.all
  end

  def show
    @open_port = Router::Rule::OpenPort.find(params[:id])
  end

  def new
    @open_port = Router::Rule::OpenPort.new
  end

  def edit
    @open_port = Router::Rule::OpenPort.find(params[:id])
  end

  def create
    @open_port = Router::Rule::OpenPort.new(params[:open_port])

    respond_to do |format|
      if @open_port.save
        format.html { redirect_to(router_open_port_url(@open_port), :notice => 'Open port was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @open_port = Router::Rule::OpenPort.find(params[:id])

    respond_to do |format|
      if @open_port.update_attributes(params[:open_port])
        format.html { redirect_to(router_open_port_url(@open_port), :notice => 'Open port was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @open_port = Router::Rule::OpenPort.find(params[:id])
    @open_port.destroy

    respond_to do |format|
      format.html { redirect_to(router_open_ports_url) }
    end
  end
end
