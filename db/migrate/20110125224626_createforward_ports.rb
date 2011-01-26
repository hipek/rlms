class CreateForwardPorts < ActiveRecord::Migration
  def self.up
    create_table :forward_ports do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :forward_ports
  end
end
