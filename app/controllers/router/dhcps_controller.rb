class Router::DhcpsController < Router::BaseController
  def index
    @dhcp = Router::Dhcp.instance
  end

  def update
    @dhcp = Router::Dhcp.instance
    if @dhcp.update_attributes params[:dhcp]
      redirect_to(router_dhcps_url, :notice => _('Settings updated successfully.'))
    else
      render :action => 'index'
    end
  end

  def destroy
    unless Router::Dhcp.instance.new_record?
      Router::Dhcp.instance.destroy
      flash[:notice] = _('Dhcp server settings have been reset to defaults')
    end
    redirect_to(router_dhcps_url)
  end
end
