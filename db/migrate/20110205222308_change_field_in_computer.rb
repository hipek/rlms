class ChangeFieldInComputer < ActiveRecord::Migration
  def self.up
    rename_column :forward_ports, :ip_address, :computer_id
    change_column :forward_ports, :computer_id, :integer
  end

  def self.down
    change_column :forward_ports, :computer_id, :string
    rename_column :forward_ports, :computer_id, :ip_address
  end
end
