require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Service do
  before(:each) do
    @service = Service.new
  end

  it "should be valid" do
    @service.should be_valid
  end
end
