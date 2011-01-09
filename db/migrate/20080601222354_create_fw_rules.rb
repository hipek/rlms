class CreateFwRules < ActiveRecord::Migration
  def self.up
    create_table :fw_rules do |t|
      t.integer :order
      t.string :ip_table
      t.string :cmd
      t.string :chain_name
      t.string :in_int
      t.string :out_int
      t.string :protocol
      t.string :src_ip
      t.string :src_port
      t.string :dest_ip
      t.string :dest_port
      t.string :to_dest_ip_port
      t.string :mod
      t.string :log
      t.string :log_msg
      t.text :description
      t.string :type
      t.integer :firewall_id

      t.timestamps
    end
  end

  def self.down
    drop_table :fw_rules
  end
end
