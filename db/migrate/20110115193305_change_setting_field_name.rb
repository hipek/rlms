class ChangeSettingFieldName < ActiveRecord::Migration
  def self.up
    rename_column :settings, :field, :field_name
  end

  def self.down
    rename_column :settings, :field_name, :field
  end
end