class CreateLocalNetworks < ActiveRecord::Migration
  def self.up
    create_table :local_networks do |t|
      t.string :name
      t.text :description
      t.integer :visibility
      t.string :int_inf
      t.string :ext_inf
      t.string :int_ip
      t.string :ext_ip

      t.timestamps
    end
  end

  def self.down
    drop_table :local_networks
  end
end
