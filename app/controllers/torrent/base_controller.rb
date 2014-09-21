class Torrent::BaseController < ApplicationController
  include MenusSupport
  submenu :torrent

  protected

  def check_permission
    return unless authorize("torrent")
  end
end
