class CreateRouterTcClassids < ActiveRecord::Migration
  def self.up
    create_table :tc_classids do |t|
      t.integer :prio
      t.string :data_transfer
      t.string :rate
      t.string :ceil

      t.timestamps
    end
  end

  def self.down
    drop_table :router_tc_classids
  end
end
