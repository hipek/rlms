class Router::ForwardPortsController < Router::BaseController
  def index
    @forward_ports = Router::Rule::ForwardPort.all
  end

  def show
    @forward_port = Router::Rule::ForwardPort.find(params[:id])
  end

  def new
    @forward_port = Router::Rule::ForwardPort.new
  end

  def edit
    @forward_port = Router::Rule::ForwardPort.find(params[:id])
  end

  def create
    @forward_port = Router::Rule::ForwardPort.new(params[:forward_port])

    respond_to do |format|
      if @forward_port.save
        format.html { redirect_to(router_forward_port_url(@forward_port), :notice => 'Forward port was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @forward_port = Router::Rule::ForwardPort.find(params[:id])

    respond_to do |format|
      if @forward_port.update_attributes(params[:forward_port])
        format.html { redirect_to(router_forward_port_url(@forward_port), :notice => 'Forward port was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @forward_port = Router::Rule::ForwardPort.find(params[:id])
    @forward_port.destroy

    respond_to do |format|
      format.html { redirect_to(router_forward_ports_url) }
    end
  end
end
