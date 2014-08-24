class SessionsController < ApplicationController
  skip_filter :login_required, :local_network_required, :authorize
  before_filter :redirect_when_logged_in, only: :new

  def new
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = {
          :value   => current_user.remember_token,
          :expires => current_user.remember_token_expires_at
        }
      end
      redirect_back_or_default url_after_login
      flash[:notice] = "Logged in successfully"
    else
      flash[:error] = "Bad login or password!"
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(root_url)
  end

  protected

  def redirect_when_logged_in
    redirect_to url_after_login if logged_in?
  end

  def url_after_login
    current_user.full_permissions_hash
    if current_user.has_permission?('admin')
      users_url
    elsif current_user.has_permission?('computers')
      router_computers_url
    elsif current_user.has_permission?('torrent')
      torrent_items_url
    else
      root_url
    end
  end
end
