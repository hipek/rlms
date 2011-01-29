class CreateRouterRuleFlows < ActiveRecord::Migration
  def self.up
    create_table :rule_flows do |t|
      t.string :port
      t.string :net_type
      t.integer :tc_classid_id
      t.string :port_type

      t.timestamps
    end
  end

  def self.down
    drop_table :rule_flows
  end
end
