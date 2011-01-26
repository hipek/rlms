class CreateOpenPorts < ActiveRecord::Migration
  def self.up
    create_table :open_ports do |t|
      t.string :port
      t.string :protocol

      t.timestamps
    end
  end

  def self.down
    drop_table :open_ports
  end
end
