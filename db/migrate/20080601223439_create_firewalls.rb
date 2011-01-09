class CreateFirewalls < ActiveRecord::Migration
  def self.up
    create_table :firewalls do |t|
      t.string :name
      t.integer :visibility
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end

  def self.down
    drop_table :firewalls
  end
end
