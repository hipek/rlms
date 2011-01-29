class AddInterfacesToServices < ActiveRecord::Migration
  def self.up
    Router::Service::ConfInit.find_or_create_by_name(:name => 'interfaces')
    Router::Service::ConfInit.find_or_create_by_name(:name => 'resolv')
  end

  def self.down
  end
end
