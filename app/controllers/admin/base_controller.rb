class Admin::BaseController < ApplicationController
  requires_permission 'admin'
  
  def index
  end
end
