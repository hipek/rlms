class Router::Rule::ForwardPort < ActiveRecord::Base
  include ::Router::Rule::OpenPort::Shared
  belongs_to :computer, :class_name => 'Router::Computer', :foreign_key => :computer_id
  
  def dports
    [dport.split(',')].flatten.compact
  end
end
