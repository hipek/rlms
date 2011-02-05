class Router::Rule::ForwardPort < ActiveRecord::Base
  belongs_to :computer, :class_name => 'Router::Computer', :foreign_key => :computer_id
end
