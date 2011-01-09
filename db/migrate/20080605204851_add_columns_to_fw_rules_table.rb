class AddColumnsToFwRulesTable < ActiveRecord::Migration
  def self.up
    remove_column :fw_rules, :to_dest_ip_port
    remove_column :fw_rules, :mod_value
    add_column :fw_rules, :mod_option, :string
    add_column :fw_rules, :mod_protocol, :string
    add_column :fw_rules, :tcp_flags, :string
    add_column :fw_rules, :tcp_flags_option, :string
    add_column :fw_rules, :aft_option, :string
    add_column :fw_rules, :aft_argument, :string
  end

  def self.down
    add_column :fw_rules, :to_dest_ip_port, :string
    add_column :fw_rules, :mod_value, :string
    remove_column :fw_rules, :mod_option
    remove_column :fw_rules, :mod_protocol
    remove_column :fw_rules, :tcp_flags
    remove_column :fw_rules, :tcp_flags_option
    remove_column :fw_rules, :aft_option
    remove_column :fw_rules, :aft_argument
  end
end
