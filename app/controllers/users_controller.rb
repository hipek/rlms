class UsersController < ApplicationController
  requires_permission "admin"
  
  def index
    @users = User.find(:all)
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

end
