class CreateRouterRuleOpenPorts < ActiveRecord::Migration
  def self.up
    create_table :router_rule_open_ports do |t|
      t.string :port
      t.string :protocol

      t.timestamps
    end
  end

  def self.down
    drop_table :router_rule_open_ports
  end
end
