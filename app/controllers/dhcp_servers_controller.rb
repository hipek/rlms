class DhcpServersController < ApplicationController
  before_filter :local_network_required

  def index
    @dhcp_server = DhcpServer.first
  end

  def update
    @dhcp_server = DhcpServer.first
    if @dhcp_server.update_attributes(params[:dhcp_server])
      flash[:notice] = 'Dhcp server settings successfully updated'
      redirect_to dhcp_servers_path
    else
      render :action => 'index'
    end
  end

end
