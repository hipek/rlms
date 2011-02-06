class Torrent::BaseController < ApplicationController
  include MenusSupport
  layout 'router_application'
  submenu :torrent
end

