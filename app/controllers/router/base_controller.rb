class Router::BaseController < ApplicationController
  include MenusSupport
  layout 'router_application'
  submenu :router
end
