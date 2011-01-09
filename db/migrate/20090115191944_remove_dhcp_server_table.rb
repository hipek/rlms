class RemoveDhcpServerTable < ActiveRecord::Migration
  def self.up
    execute("drop table dhcp_servers")
    execute("drop table local_networks")    
  end

  def self.down
  end
end
