class Router::Rule::OpenPortsController < Router::BaseController
  # GET /router/rule/open_ports
  # GET /router/rule/open_ports.xml
  def index
    @router_rule_open_ports = Router::Rule::OpenPort.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @router_rule_open_ports }
    end
  end

  # GET /router/rule/open_ports/1
  # GET /router/rule/open_ports/1.xml
  def show
    @router_rule_open_port = Router::Rule::OpenPort.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @router_rule_open_port }
    end
  end

  # GET /router/rule/open_ports/new
  # GET /router/rule/open_ports/new.xml
  def new
    @router_rule_open_port = Router::Rule::OpenPort.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @router_rule_open_port }
    end
  end

  # GET /router/rule/open_ports/1/edit
  def edit
    @router_rule_open_port = Router::Rule::OpenPort.find(params[:id])
  end

  # POST /router/rule/open_ports
  # POST /router/rule/open_ports.xml
  def create
    @router_rule_open_port = Router::Rule::OpenPort.new(params[:router_rule_open_port])

    respond_to do |format|
      if @router_rule_open_port.save
        format.html { redirect_to(@router_rule_open_port, :notice => 'Open port was successfully created.') }
        format.xml  { render :xml => @router_rule_open_port, :status => :created, :location => @router_rule_open_port }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @router_rule_open_port.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /router/rule/open_ports/1
  # PUT /router/rule/open_ports/1.xml
  def update
    @router_rule_open_port = Router::Rule::OpenPort.find(params[:id])

    respond_to do |format|
      if @router_rule_open_port.update_attributes(params[:router_rule_open_port])
        format.html { redirect_to(@router_rule_open_port, :notice => 'Open port was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @router_rule_open_port.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /router/rule/open_ports/1
  # DELETE /router/rule/open_ports/1.xml
  def destroy
    @router_rule_open_port = Router::Rule::OpenPort.find(params[:id])
    @router_rule_open_port.destroy

    respond_to do |format|
      format.html { redirect_to(router_rule_open_ports_url) }
      format.xml  { head :ok }
    end
  end
end
