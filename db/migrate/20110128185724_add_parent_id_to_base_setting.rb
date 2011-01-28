class AddParentIdToBaseSetting < ActiveRecord::Migration
  def self.up
    add_column :base_settings, :parent_id, :integer
  end

  def self.down
    remove_column :base_settings, :parent_id
  end
end
