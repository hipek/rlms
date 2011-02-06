class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include GetText

  helper :all

  layout 'application'

  before_filter :login_required, :authorize

  protected

  def params_or_session key
    session[key] = params.key?(key) ? params[key] : session[key]
  end

  def access_denied
    flash[:error] = "You don't have sufficient privileges to access this section."
    redirect_to request.env["HTTP_REFERER"] || root_url
    false
  end

  def authorize(permissions = [])
    if c = current_user
      c.full_permissions_hash
      return true if c.has_permission?(*permissions)
    end
    access_denied
  end
  
  def self.requires_permission perm
    define_method :authorize do
      super perm
    end
    protected :authorize
  end
end
