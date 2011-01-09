class AddIpToComputers < ActiveRecord::Migration
  def self.up
    add_column :computers, :ip_address, :string
  end

  def self.down
    remove_column :computers, :ip_address
  end
end
