require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/forward_ports/index" do
  before(:each) do
    assigns[:fw_rules] = @fw_rules = []
    render 'forward_ports/index'
  end
  
  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.capture(:col2).should have_tag('table')
  end
end
