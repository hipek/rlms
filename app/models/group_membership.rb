class GroupMembership < ActiveRecord::Base
  #belongs_to :user
  belongs_to :group
  belongs_to :roleable, :polymorphic => true
  
  validates_presence_of :roleable_id, :roleable_type, :group_id
  validates_uniqueness_of :group_id, :scope => [:roleable_id, :roleable_type]
  validates_numericality_of :roleable_id, :group_id
  validates_format_of :roleable_type, :with => /^[A-Z]{1}[a-z0-9]+([A-Z]{1}[a-z0-9]+)*$/
  validate :group_does_not_belong_to_itself_in_a_loop
  
  protected
  def group_does_not_belong_to_itself_in_a_loop
    if roleable_type == "Group"
      if group_id == roleable_id
        errors.add(:base, "A group cannot belong to itself.")
      else
        if belongs_to_itself_through_other?(roleable_id, group_id)
          errors.add(:base, "A group cannot belong to a group which belongs to it.")
        end
      end
    end
  end
  
  def belongs_to_itself_through_other?(original_roleable_id, current_group_id)
    if self.class.find(:first, :select => "id", :conditions => ["roleable_id=? AND roleable_type='Group' AND group_id=?",current_group_id,original_roleable_id])
      return true
    else
      memberships = self.class.find(:all, :select => "group_id", :conditions => ["roleable_id=? AND roleable_type='Group'",current_group_id])
      if memberships.any? {|membership| belongs_to_itself_through_other?(original_roleable_id,membership.group_id)}
        return true
      end
    end
    return false
  end
end