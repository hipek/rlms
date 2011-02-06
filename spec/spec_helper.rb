# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'factory'

include AuthenticatedTestHelper
include Factory
# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
end

def stub_current_user user=mock_model(User)
  @controller.template.stub!(:current_user).and_return(user)
end

def build_service params={}
  Service.new({ 
    :name => 'service_name',
    :init_path => '/tmp/init.path',
    :config_path => '/etc/program/path.conf',
    :bin_path => '/sbin/program'
  }.merge(params))
end

def build_computer params={}
  c = Computer.new({
    :mac_address => "00:ab:bc:cd:12:12", 
    :name => 'iT a cool Bame', 
    :ip_address => "1.1.1.1"  
  }.merge(params))
  c.stub!(:id).and_return(params[:id])
  c
end

def build_model model, options={}
  m = model.new options
  m.stub!(:id).and_return(options[:id])
  m
end
