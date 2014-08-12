# ActsAsPermissible
module NoamBenAri
  module Acts #:nodoc:
    module Permissible #:nodoc:

      def self.included(base)
        base.extend ClassMethods  
      end

      module ClassMethods
        def acts_as_permissible
          has_many :permissions, :as => :permissible, :dependent => :destroy
          
          has_many :group_memberships, :as => :roleable, :dependent => :destroy
          has_many :groups, :through => :group_memberships, :source => :group
          
          include NoamBenAri::Acts::Permissible::InstanceMethods
          extend NoamBenAri::Acts::Permissible::SingletonMethods
        end
      end
      
      # This module contains class methods
      module SingletonMethods
        
        # Helper method to lookup for permissions for a given object.
        # This method is equivalent to obj.permissions.
        def find_permissions_for(obj)
          permissible = obj.class.base_class.name
         
          Permission.where(["permissible_id = ? and permissible_type = ?", obj.id, permissible])
        end
      end
      
      # This module contains instance methods
      module InstanceMethods
        
        # returns permissions in hash form
        def permissions_hash
          @permissions_hash ||= permissions.inject({}) { |hsh,perm| hsh.merge(perm.to_hash) }.symbolize_keys!
        end
        
        # accepts a permission identifier string or an array of permission identifier strings
        # and return true if the user has all of the permissions given by the parameters
        # false if not.
        def has_permission?(*perms)
          perms.all? {|perm| permissions_hash.include?(perm.to_sym) && (permissions_hash[perm.to_sym] == true) }
        end
        
        # accepts a permission identifier string or an array of permission identifier strings
        # and return true if the user has any of the permissions given by the parameters
        # false if none.
        def has_any_permission?(*perms)
          perms.any? {|perm| permissions_hash.include?(perm.to_sym) && (permissions_hash[perm.to_sym] == true) }
        end
        
        # Merges another permissible object's permissions into this permissible's permissions hash
        # In the case of identical keys, a false value wins over a true value.
        def merge_permissions!(other_permissions_hash)
          permissions_hash.merge!(other_permissions_hash) {|key,oldval,newval| oldval.nil? ? newval : oldval && newval}
        end

        # Resets permissions and then loads them.
        def reload_permissions!
          reset_permissions!
          permissions_hash
        end
        
        def groups_list
          list = []
          groups.inject(list) do |list,group|
             list << group.name
             group.groups_list.inject(list) {|list,group| list << group}
          end
          list.uniq
        end
        
        def in_group?(*group_names)
          group_names.all? {|group| groups_list.include?(group) }
        end
        
        def in_any_group?(*group_names)
          group_names.any? {|group| groups_list.include?(group) }
        end
        
        def full_permissions_hash
          permissions_hash
          groups.each do |group|
            merge_permissions!(group.full_permissions_hash)
          end
          permissions_hash
        end
        
        private
        # Nilifies permissions_hash instance variable.
        def reset_permissions!
          @permissions_hash = nil
        end
          
      end
    end
  end
end
