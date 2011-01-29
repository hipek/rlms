module Router::TcClassidsHelper
  def priorities
    [
      ['Network', -1],
      ['Very High', 0],
      ['High', 1],
      ['Medium High', 2],
      ['Medium Low', 3],
      ['Low', 4],
      ['Very Low', 5],
    ]
  end

  def display_priority prio
    priorities.find{|o| o.last == prio}.first
  end

  def display_data_transfer d
    data_transfers.find{|a| a.last == d}.first
  end

  def data_transfers
    [
      ['Download', 'int'],
      ['Upload', 'ext']
    ]
  end
end
