class Permission < ActiveRecord::Base
  belongs_to :group
  
  belongs_to :permissible, :polymorphic => true
  
  validates_presence_of :permissible_id, :permissible_type, :action
  validates_format_of :action, :with => /\A[a-z_]+\z/
  validates_numericality_of :permissible_id
  validates_uniqueness_of :action, :scope => [:permissible_id,:permissible_type]

  PERMISSIONS = %w[
    admin firewalls services networks
    computers computer_delete computer_create computer_update
    torrent
  ]

  def to_hash
    self.new_record? ? {} : {self.action => self.granted}
  end
  
  def self.find_or_create_by_group_id_and_action(group_id, permission)
    where(permissible_type: 'Group', permissible_id: group_id, action: permission, granted: true).first_or_create
  end

  def self.find_by_group_id_and_action(group_id, permission)
    where(permissible_type: 'Group', permissible_id: group_id, action: permission, granted: true).first
  end  
end
