class ForwardPortsController < ApplicationController
  def index
    FwRuleContainer.read
    @fw_rules = FwRuleContainer.forward_ports
  end

end
