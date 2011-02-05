require 'spec_helper'

describe Router::Interface do
  describe "subnet_mask" do
    before(:each) do
      @interface = build_router_interface(:ip_address => '10.1.1.1')
    end

    it "should return subnet mask" do
      @interface.ip_mask = '255.0.0.0'
      @interface.subnet_short_mask.should == '8'
    end

    it "should return subnet mask for 2" do
      @interface.ip_mask = '255.255.0.0'
      @interface.subnet_short_mask.should == '16'
    end

    it "should return subnet mask for 3" do
      @interface.ip_mask = '255.255.255.0'
      @interface.subnet_short_mask.should == '24'
    end
  end
end
