class AddBinPathToService < ActiveRecord::Migration
  def self.up
    add_column :services, :bin_path, :string
  end

  def self.down
    remove_column :services, :bin_path
  end
end
