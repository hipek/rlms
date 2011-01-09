class Permission < ActiveRecord::Base
  # uncomment any of the following lines which is relevant to your application,
  # or create your own with the name of the model which acts_as_permissible.
  #belongs_to :user
  
  belongs_to :group
  
  belongs_to :permissible, :polymorphic => true
  
  validates_presence_of :permissible_id, :permissible_type, :action
  validates_format_of :action, :with => /^[a-z_]+$/
  validates_numericality_of :permissible_id
  validates_uniqueness_of :action, :scope => [:permissible_id,:permissible_type]

  PERMISSIONS = %w[
    admin firewalls services networks computers computer_delete computer_create computer_update
  ]

  def to_hash
    self.new_record? ? {} : {self.action => self.granted}
  end
  
  def self.find_or_create_by_group_id_and_action group_id, permission
    find_or_create_by_permissible_type_and_permissible_id_and_action_and_granted('Group', group_id, permission, true)
  end

  def self.find_by_group_id_and_action group_id, permission
    find_by_permissible_type_and_permissible_id_and_action_and_granted('Group', group_id, permission, true)
  end
  
end
