class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.string :name
      t.string :init_path
      t.string :config_path
      t.integer :visibility
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :services
  end
end
