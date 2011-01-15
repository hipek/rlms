class FirewallsController < ApplicationController
  before_filter :local_network_required

  def index
    @firewalls = current_lan.firewalls.find(:all)
  end

  def show
    @firewall = current_lan.firewalls.find_by_id(params[:id])
  end

  def new
    @firewall = current_lan.firewalls.build
  end

  def edit
    @firewall = current_lan.firewalls.find_by_id(params[:id])
  end

  def create
    @firewall = current_lan.firewalls.build(params[:firewall])

    respond_to do |format|
      if @firewall.save
        flash[:notice] = 'Firewall was successfully created.'
        format.html { redirect_to(@firewall) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @firewall = current_lan.firewalls.find_by_id(params[:id])

    respond_to do |format|
      if @firewall.update_attributes(params[:firewall])
        p :here
        flash[:notice] = 'Firewall was successfully updated.'
        format.html { redirect_to(@firewall) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @firewall = current_lan.firewalls.find_by_id(params[:id])
    @firewall.destroy

    respond_to do |format|
      format.html { redirect_to(firewalls_url) }
    end
  end
end
