class AddLanIdToDhcpServer < ActiveRecord::Migration
  def self.up
    add_column :dhcp_servers, :lan_id, :integer
  end

  def self.down
    remove_column :dhcp_servers, :lan_id
  end
end
