class Router::FlowsController < Router::BaseController
  def index
    @router_flows = Router::Rule::Flow.all
  end

  def new
    @router_flow = Router::Rule::Flow.new
  end

  def edit
    @router_flow = Router::Rule::Flow.find(params[:id])
  end

  def create
    @router_flow = Router::Rule::Flow.new(params[:router_flow])

    respond_to do |format|
      if @router_flow.save
        format.html { redirect_to(router_flows_url, :notice => 'Flow was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @router_flow = Router::Rule::Flow.find(params[:id])

    respond_to do |format|
      if @router_flow.update_attributes(params[:router_flow])
        format.html { redirect_to(router_flows_url, :notice => 'Flow was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @router_flow = Router::Rule::Flow.find(params[:id])
    @router_flow.destroy

    respond_to do |format|
      format.html { redirect_to(router_flows_url) }
    end
  end
end
