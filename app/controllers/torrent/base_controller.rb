class Torrent::BaseController < ApplicationController
  include MenusSupport
  layout 'router_application'
  submenu :torrent

  protected

  def check_permission
    return unless authorize("torrent")
  end
end
