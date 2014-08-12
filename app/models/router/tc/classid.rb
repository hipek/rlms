class Router::Tc::Classid < ActiveRecord::Base
  self.table_name = 'tc_classids'

  NETWORK = -1
  HIGHEST = 0
  HIGHER  = 1
  HIGH    = 2
  LOW     = 3
  LOWER   = 4
  LOWEST  = 5

  PRIORITIES = {
    'Network' => -1,
    'Highest' => 0,
    'Higher' => 1,
    'High' => 2,
    'Low' => 3,
    'Lower' => 4,
    'Lowest' => 5
  }

  EXT = 'ext'
  INT = 'int'
  
  NET_TYPES = {
    'Download' => INT,
    'UPLOAD' => EXT
  }

  has_many :flow_rules, :class_name => 'Router::Rule::Flow', :foreign_key => 'tc_classid_id'

  scope :download, ->{ where(:net_type => 'int') }
  scope :upload, ->{ where(:net_type => 'ext') }
  scope :net_type, lambda {|t| where(:net_type => t)}
  scope :ordered, ->{ order('net_type DESC, prio ASC') }
  scope :no_network, ->{ where("prio != ?", NETWORK) }

  class <<self
    def priorities
      PRIORITIES
    end

    def net_types
      NET_TYPES
    end

    def all_as_pairs
      no_network.ordered.map{|c| 
        [c.full_name, c.id]
      }
    end
  end

  def priority
    self.class.priorities.index(prio).to_s
  end

  def full_name
    "(" + self.class.net_types.index(net_type).to_s + ") " + priority
  end
end
