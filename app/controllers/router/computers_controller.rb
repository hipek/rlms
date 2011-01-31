class Router::ComputersController < Router::BaseController
  before_filter :check_permission, :only => [:index, :show, :block, :pass]
  
  def index
    FwRuleContainer.read
    @computers = Router::Computer.find(:all, :order => Router::Computer::SORT_BY_IP)
    @online_computers = Router::Computer.all_online
    @online_ips = @online_computers.map(&:ip_address)
    @online_computers = @online_computers.select{|cmp| !@computers.map(&:mac_address).include?(cmp.mac_address.upcase)}
    @blocked_ips = FwRule.blocked_ips
  end

  def show
    @computer = Router::Computer.find(params[:id])
  end

  def dhcp_list
    @dhcp_server = Router::Dhcp.instance
    @conf_template = @dhcp_server.install_conf
  end
  
  def block
    if @computer = Router::Computer.find_by_id(params[:id])  
      #@computer.block(current_lan.default_firewall)
      flash[:notice] = "Blocked successfully"
    end
    redirect_to router_computers_path
  end
  
  def pass
    if @computer = Router::Computer.find_by_id(params[:id])
      #@computer.pass(current_lan.default_firewall)
      flash[:notice] = "Passed successfully"
    end
    redirect_to router_computers_path
  end

  def new
    return unless authorize("computer_create")
    @computer = Router::Computer.new(params[:router_computer] || {})
    @computer.ip_address = Router::Computer.next_ip if Router::Computer.next_ip
  end

  def edit
    return unless authorize("computer_update")
    @computer = Router::Computer.find(params[:id])
  end
  
  def create
    return unless authorize("computer_create")
    @computer = Router::Computer.new(params[:router_computer])
    
    respond_to do |format|
      if @computer.save
        flash[:notice] = 'Computer was successfully created.'
        format.html { redirect_to router_computers_path }
        restart_dhcpd
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    return unless authorize("computer_update")
    @computer ||= Router::Computer.find(params[:id])

    respond_to do |format|
      if @computer.update_attributes(params[:router_computer])
        flash[:notice] = 'Computer was successfully updated.'
        format.html { redirect_to router_computers_path }
        restart_dhcpd
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    return unless authorize("computer_delete")
    @computer = Router::Computer.find(params[:id])
    @computer.destroy

    respond_to do |format|
      format.html { redirect_to(router_computers_url) }
    end
  end
  
  protected

  def restart_dhcpd
    @dhcp_server = Router::Dhcp.instance
    @conf_template = @dhcp_server.install_conf
    ShellCommand.install_dhcpd_config @conf_template
    flash[:warn] = ShellCommand.install_dhcpd_config @conf_template
    flash[:warn] = ShellCommand.restart_dhcpd if flash[:warn].blank?
  end
  
  def check_permission
    return unless authorize("computers")
  end
end
