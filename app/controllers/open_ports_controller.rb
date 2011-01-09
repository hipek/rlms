class OpenPortsController < ApplicationController
  def index
    FwRuleContainer.read
    @fw_rules = FwRuleContainer.in_open_ports
  end

end
