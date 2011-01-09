class AddModValueToFirewallRule < ActiveRecord::Migration
  def self.up
    add_column :fw_rules, :mod_value, :string
  end

  def self.down
    remove_column :fw_rules, :mod_value
  end
end
