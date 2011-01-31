class Router::Tc::Classid < ActiveRecord::Base
  set_table_name 'tc_classids'

  has_many :flow_rules, :class_name => 'Router::Rule::Flow', :foreign_key => 'tc_classid_id'
  
  scope :download, where(:net_type => 'int')
  scope :upload, where(:net_type => 'ext')
end
