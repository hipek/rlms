require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BaseSetting do
  before(:each) do
    @base_setting = BaseSetting.new
  end

  it "should be valid" do
    @base_setting.should be_valid
  end
end
