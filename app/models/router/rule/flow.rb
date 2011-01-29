class Router::Rule::Flow < ActiveRecord::Base
  set_table_name 'rule_flows'

  belongs_to :tc_classid, :class_name => 'Router::Tc::Classid', :foreign_key => 'tc_classid_id'
end
