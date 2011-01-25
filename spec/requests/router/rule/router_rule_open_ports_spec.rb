require 'spec_helper'

describe "Router::Rule::OpenPorts" do
  describe "GET /router_rule_open_ports" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get router_rule_open_ports_path
      response.status.should be(200)
    end
  end
end
