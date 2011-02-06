class AddActiveToComputer < ActiveRecord::Migration
  def self.up
    add_column :computers, :active, :boolean, :null => false, :default => 1
  end

  def self.down
    remove_column :computers, :active
  end
end
