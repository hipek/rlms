class Group < ActiveRecord::Base
  has_many :group_memberships, :as => :roleable, :dependent => :destroy
  has_many :groups, :through => :group_memberships, :source => :group
  
  has_many :roleables, :class_name => "GroupMembership", :foreign_key => "group_id", :dependent => :destroy
  #has_many :subgroups, :through => :roleables, :source => :roleable, :source_type => 'Group'
  #has_many :users, :through => :roleables, :source => :roleable, :source_type => 'User'
  
  validates_uniqueness_of :name
  
  acts_as_permissible
  
  GROUPS = %w[
     administrator user operator
   ].freeze

  class << self
    GROUPS.each do |group|
      class_eval "
        def #{group}
          @@_role_#{group}_ ||= find_or_create_by_name('#{group}')
        end"
    end

    def all_groups
      GROUPS.map { |role| Group.send role }
    end
        
    def all_as_pairs
      map_to_pairs(all)
    end
        
    def map_to_pairs options={}
      options.map{|r| [r.name, r.id]}
    end
  end

end
