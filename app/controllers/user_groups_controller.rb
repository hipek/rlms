class UserGroupsController < ApplicationController
  requires_permission "admin"
  
  def index
    @users = User.filtered_by_login(params[:q]).
      filtered_by_group_id(params[:group_id]).
      order("id DESC").
      paginate(:page => params[:page], :per_page => 50)
    @groups = Group.all_groups
  end
  
  def update
    user = User.find params[:user_id]
    group = Group.find params[:group_id]
    if params[:value] == "true"
      user.groups << group
    else
      user.groups.delete group
    end
    render :nothing => true
  end

end
