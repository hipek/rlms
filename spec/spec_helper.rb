# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'

include AuthenticatedTestHelper

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  #
  # For more information take a look at Spec::Example::Configuration and Spec::Runner
end

def stub_shell_commands
  Service.stub!(:find_by_name).and_return(mock('service', :bin_path => '', :config_path => '/tmp', :init_path => '/tmp'))
  ShellCommand.stub!(:run_command).and_return('')
end

def array_to_will_paginate elements, page=1, per_page=100
  WillPaginate::Collection.new(page, per_page, elements.length).concat(elements)
end

def add_permission group, permission
  Permission.find_or_create_by_group_id_and_action(group.id, permission)
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
  Computer.new({
    :mac_address => "00:ab:bc:cd:12:12", 
    :name => 'iT a cool Bame', 
    :ip_address => "1.1.1.1"  
  }.merge(params))
end

def build_local_network params={}
  LocalNetwork.new({
    :name => "TestLan",
    :int_inf => 'eth0',
    :int_ip =>'10.5.5.100',
    :ext_inf => 'eth1',
    :ext_ip => '96.130.22.19'
  }.merge(params))
end

def build_dhcp_server(options={})
  DhcpServer.new({
                   :router => '10.5.5.1',
                   :subnet => '10.0.0.0',
                   :broadcast_address => '10.255.255.255',
                   :range_from => '10.5.5.10',
                   :range_to => '10.5.5.20',
                   :subnet_mask => '255.0.0.0',
                   :domain_name_server1 => '194.204.159.1',
                   :domain_name_server2 => '194.204.152.34',
                 }.merge(options))
end
