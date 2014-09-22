class UsersController < ApplicationController
  include MenusSupport
  submenu :admin

  requires_permission "admin"
  
  def index
    @users = User.all
  end

  def new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "User created successfully!"
      redirect_to users_path
    else
      render :action => 'new'
    end
  end

  def destroy
    u = User.find_by_id(params[:id])
    u.try(:destroy)
    redirect_to users_url
  end
end
