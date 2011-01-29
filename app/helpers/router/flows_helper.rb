module Router::FlowsHelper
  def port_types
    %w"dport sport"
  end
  
  def display_port_type t
    port_types.find{|a| a == t}
  end
end
