module Router::TcClassidsHelper
  def priorities
    [
      ['Network', -1],
      ['Highest', 0],
      ['Higher', 1],
      ['High', 2],
      ['Low', 3],
      ['Lower', 4],
      ['Lowest', 5],
    ]
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
