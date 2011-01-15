# Include hook code here
begin
  require "#{Rails.root}/lib/acts_as_permissible"
  ActiveRecord::Base.send(:include, NoamBenAri::Acts::Permissible)
rescue MissingSourceFile => m
  
end