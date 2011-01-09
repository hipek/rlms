class CreateGroupMemberships < ActiveRecord::Migration
  def self.up
    create_table :group_memberships do |t|
      t.integer :roleable_id
      t.string :roleable_type
      t.integer :group_id

      t.timestamps
    end
  end

  def self.down
    drop_table :group_memberships
  end
end