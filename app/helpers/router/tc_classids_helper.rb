module Router::TcClassidsHelper
  def priorities
    order = %w'Network Highest Higher High Low Lower Lowest'
    Router::Tc::Classid.priorities.sort{|x, y| order.index(x.first) <=> order.index(y.first)}
  end

  def display_priority prio
    priorities.find{|o| o.last == prio}.first
  end

  def display_net_type d
    net_types.find{|a| a.last == d}.first
  end

  def net_types
    [
      ['Download', 'int'],
      ['Upload', 'ext']
    ]
  end
end
