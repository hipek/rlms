# == Schema Information
#
# Table name: settings
#
#  id              :integer(11)     not null, primary key
#  field           :string(255)     
#  value           :string(255)     
#  base_setting_id :integer(11)     
#  created_at      :datetime        
#  updated_at      :datetime        
#

class Setting < ActiveRecord::Base
end
