class AddLanIdToFirewall < ActiveRecord::Migration
  def self.up
    add_column :firewalls, :lan_id, :integer
  end

  def self.down
    remove_column :firewalls, :lan_id
  end
end
