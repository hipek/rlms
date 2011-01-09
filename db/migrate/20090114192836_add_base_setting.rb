class AddBaseSetting < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.string :field
      t.string :value
      t.integer :base_setting_id

      t.timestamps
    end
    create_table :base_settings do |t|
      #t.integer :env_id
      t.string :type

      t.timestamps
    end

  end
  
  def self.down
    drop_table :base_settings
    drop_table :settings
  end
end
