class Router::DhcpsController < ApplicationController
  def index
  end

  def update
    redirect_to(router_dhcps_url)
  end
end
