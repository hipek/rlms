class CreateForwardPorts < ActiveRecord::Migration
  def self.up
    create_table :forward_ports do |t|
      t.string :port
      t.string :protocol
      t.string :ip_address

      t.timestamps
    end
  end

  def self.down
    drop_table :forward_ports
  end
end
