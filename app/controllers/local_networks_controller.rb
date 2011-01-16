class LocalNetworksController < ApplicationController
  requires_permission "networks"
  
  before_filter :load_interfaces, :only => [:index, :update]
  
  def index
    @local_network = current_lan
  end

  def update
    @local_network = current_lan
    if @local_network.update_attributes(params[:local_network])
      flash[:notice] = 'Lan settings successfully updated'
      redirect_to local_networks_path
    else
      render :action => 'index'
    end
  end
  
  def get_ip
    ip_address = ShellCommand.ip(params[:int])
    render :update do |page|
      page << "$('local_network_#{params[:id]}').value = '#{ip_address}';"
    end
  end
  
  protected
  
  def load_interfaces
    @interfaces = ShellCommand.read_interfaces
  end
end
