require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/group_permissions/index" do
  before(:each) do
    assigns[:groups] = [Group.user]
    assigns[:permissions] = Permission::PERMISSIONS
    assigns[:group_permissions] = []

  end

  it "should render index" do
    render 'group_permissions/index'
    response.should_not be_nil
  end
end
