class GroupPermissionsController < ApplicationController
  include MenusSupport
  submenu :admin

  requires_permission 'admin'
   
  def index
    @groups = Group.all_groups
    @group_permissions = Permission.all.map{|perm| {perm.permissible_id => perm.action}}
    @permissions = Permission::PERMISSIONS
  end

  def update
    if params[:value] == 'true'
      @permission = Permission.find_or_create_by_group_id_and_action(params[:group_id], params[:permission])
    else
      Permission.find_by_group_id_and_action(params[:group_id], params[:permission]).try:destroy
    end
    render :nothing => true
  end
end
