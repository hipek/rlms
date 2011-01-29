class AddRenameFieldsInTcClassid < ActiveRecord::Migration
  def self.up
    add_column :tc_classids, :router_id, :integer
    rename_column :tc_classids, :data_transfer, :net_type
  end

  def self.down
    rename_column :tc_classids, :net_type, :data_transfer
    remove_column :tc_classids, :router_id
  end
end
