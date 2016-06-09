require 'rails_helper'

describe SessionsController do
  fixtures :users
  render_views

  it 'logins and redirects' do
    post :create, :login => 'quentin', :password => 'test'
    expect(session[:user_id]).to_not be_nil
    expect(response).to be_redirect
  end

  it 'fails login and does not redirect' do
    post :create, :login => 'quentin', :password => 'bad password'
    expect(session[:user_id]).to be_nil
    expect(response).to be_success
  end

  it 'logs out' do
    login_as :quentin
    get :destroy
    expect(session[:user_id]).to be_nil
    expect(response).to be_redirect
  end

  it 'remembers me' do
    post :create, :login => 'quentin', :password => 'test', :remember_me => "1"
    expect(response.cookies["auth_token"]).to_not be_nil
  end

  it 'does not remember me' do
    post :create, :login => 'quentin', :password => 'test', :remember_me => "0"
    expect(response.cookies["auth_token"]).to be_nil
  end

  it 'deletes token on logout' do
    login_as :quentin
    get :destroy
    expect(response.cookies["auth_token"]).to eq nil
  end

  it 'logs in with cookie' do
    users(:quentin).remember_me
    request.cookies["auth_token"] = cookie_for(:quentin)
    get :new
    expect(controller.send(:logged_in?)).to eql true
  end

  it 'fails expired cookie login' do
    users(:quentin).remember_me
    users(:quentin).update_attribute :remember_token_expires_at, 5.minutes.ago
    request.cookies["auth_token"] = cookie_for(:quentin)
    get :new
    expect(controller.send(:logged_in?)).to_not eql true
  end

  it 'fails cookie login' do
    users(:quentin).remember_me
    request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :new
    expect(controller.send(:logged_in?)).to_not eql true
  end

  def auth_token(token)
    CGI::Cookie.new('name' => 'auth_token', 'value' => token)
  end

  def cookie_for(user)
    auth_token users(user).remember_token
  end
end
