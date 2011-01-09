class AddTargetToFirewallRule < ActiveRecord::Migration
  def self.up
    add_column :fw_rules, :target, :string
  end

  def self.down
    remove_column :firewalls, :target
  end
end
