class RemoveOldTable < ActiveRecord::Migration
  def self.up
    execute("drop table dhcp_server_computers")
  end

  def self.down
  end
end
