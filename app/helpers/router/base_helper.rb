module Router::BaseHelper
  def all_protocols
    %w"TCP UDP ALL".map{|pro| [pro, pro.downcase]}
  end
end
