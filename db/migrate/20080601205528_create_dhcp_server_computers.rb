class CreateDhcpServerComputers < ActiveRecord::Migration
  def self.up
    create_table :dhcp_server_computers do |t|
      t.integer :dhcp_server_id
      t.integer :computer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :dhcp_server_computers
  end
end
