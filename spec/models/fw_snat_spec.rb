require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FwSnat do
  before(:each) do
    @fw_snat = FwSnat.new
  end

  it "should be valid" do
    @fw_snat.should be_valid
  end
end
