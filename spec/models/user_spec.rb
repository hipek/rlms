require 'rails_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead.
# Then, you can remove it from this and the functional test.
include AuthenticatedTestHelper

describe User do
  fixtures :users

  describe 'being created' do
    before do
      @user = nil
      @creating_user = lambda do
        @user = create_user
        violated "#{@user.errors.full_messages.to_sentence}" if @user.new_record?
      end
    end

    it 'increments User#count' do
      expect(@creating_user).to change(User, :count).by(1)
    end
  end

  it 'requires login' do
    expect(lambda do
      u = create_user(:login => nil)
      expect(u.errors[:login]).to_not be_nil
    end).to_not change(User, :count)
  end

  it 'requires password' do
    expect(lambda do
      u = create_user(:password => nil)
      expect(u.errors[:password]).to_not be_nil
    end).to_not change(User, :count)
  end

  it 'requires password confirmation' do
    expect(lambda do
      u = create_user(:password_confirmation => nil)
      expect(u.errors[:password_confirmation]).to_not be_nil
    end).to_not change(User, :count)
  end

  it 'requires email' do
    expect(lambda do
      u = create_user(:email => nil)
      expect(u.errors[:email]).to_not be_nil
    end).to_not change(User, :count)
  end

  it 'resets password' do
    users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    expect(User.authenticate('quentin', 'new password')).to eq users(:quentin)
  end

  it 'does not rehash password' do
    users(:quentin).update_attributes(:login => 'quentin2')
    expect(User.authenticate('quentin2', 'test')).to eq users(:quentin)
  end

  it 'authenticates user' do
    expect(User.authenticate('quentin', 'test')).to eq users(:quentin)
  end

  it 'sets remember token' do
    users(:quentin).remember_me
    expect(users(:quentin).remember_token).to_not be_nil
    expect(users(:quentin).remember_token_expires_at).to_not be_nil
  end

  it 'unsets remember token' do
    users(:quentin).remember_me
    expect(users(:quentin).remember_token).to_not be_nil
    users(:quentin).forget_me
    expect(users(:quentin).remember_token).to be_nil
  end

  it 'remembers me for one week' do
    before = 1.week.from_now.utc
    users(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    expect(users(:quentin).remember_token).to_not be_nil
    expect(users(:quentin).remember_token_expires_at).to_not be_nil
    expect(users(:quentin).remember_token_expires_at.between?(before, after)).to eql true
  end

  it 'remembers me until one week' do
    time = 1.week.from_now.utc
    users(:quentin).remember_me_until time
    expect(users(:quentin).remember_token).to_not be_nil
    expect(users(:quentin).remember_token_expires_at).to_not be_nil
    expect(users(:quentin).remember_token_expires_at).to eq time
  end

  it 'remembers me default two weeks' do
    before = 2.weeks.from_now.utc
    users(:quentin).remember_me
    after = 2.weeks.from_now.utc
    expect(users(:quentin).remember_token).to_not be_nil
    expect(users(:quentin).remember_token_expires_at).to_not be_nil
    expect(users(:quentin).remember_token_expires_at.between?(before, after)).to eql true
  end

protected
  def create_user(options = {})
    record = User.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    record.save
    record
  end
end
