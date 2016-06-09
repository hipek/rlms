require 'rails_helper'

describe UsersController do
  fixtures :users, :groups, :group_memberships
  render_views

  before(:each) do
    login_as(:admin)
    add_permission groups(:administrator), "admin"
  end

  it 'allows signup' do
    expect(lambda do
      create_user
      expect(response).to be_redirect
    end).to change(User, :count).by(1)
  end

  it 'requires login on signup' do
    expect(lambda do
      create_user(:login => nil)
      expect(assigns[:user].errors[:login]).to_not be_nil
      expect(response).to be_success
    end).to_not change(User, :count)
  end

  it 'requires password on signup' do
    expect(lambda do
      create_user(:password => nil)
      expect(assigns[:user].errors[:password]).to_not be_nil
      expect(response).to be_success
    end).to_not change(User, :count)
  end

  it 'requires password confirmation on signup' do
    expect(lambda do
      create_user(:password_confirmation => nil)
      expect(assigns[:user].errors[:password_confirmation]).to_not be_nil
      expect(response).to be_success
    end).to_not change(User, :count)
  end

  it 'requires email on signup' do
    expect(lambda do
      create_user(:email => nil)
      expect(assigns[:user].errors[:email]).to_not be_nil
      expect(response).to be_success
    end).to_not change(User, :count)
  end

  def create_user(options = {})
    post :create, :user => { :login => 'quire', :email => 'quire@example.com',
      :password => 'quire', :password_confirmation => 'quire' }.merge(options)
  end

  describe "GET 'users'" do
    it "should be successfull" do
      get :index
      expect(response).to be_success
    end
  end
end
