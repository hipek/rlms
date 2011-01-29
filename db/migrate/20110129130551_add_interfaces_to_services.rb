class AddInterfacesToServices < ActiveRecord::Migration
  def self.up
    Router::Service::ConfInit.find_or_create_by_name(:name => 'interfaces')
  end

  def self.down
  end
end
