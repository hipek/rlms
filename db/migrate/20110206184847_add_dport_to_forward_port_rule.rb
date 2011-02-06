class AddDportToForwardPortRule < ActiveRecord::Migration
  def self.up
    add_column :forward_ports, :dport, :string
  end

  def self.down
    remove_column :forward_ports, :dport
  end
end
