class CreateDhcpServers < ActiveRecord::Migration
  def self.up
    create_table :dhcp_servers do |t|
      t.string :domain_name
      t.string :domain_name_server1
      t.string :domain_name_server2
      t.string :subnet_mask
      t.integer :default_lease_time
      t.integer :max_lease_time
      t.string :subnet
      t.string :broadcast_address
      t.string :router
      t.string :range_from
      t.string :range_to

      t.timestamps
    end
  end

  def self.down
    drop_table :dhcp_servers
  end
end
