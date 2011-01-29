require 'spec_helper'

describe Router::Main do
  describe "Instance" do
    before(:each) do
      @router_main = build_router_main
    end

    it "should return int inferface" do
      @router_main.int_inf.net_type.should == 'int'
    end

    it "should return ext inferface" do
      @router_main.ext_inf.net_type.should == 'ext'
    end

    it "should be valid" do
      @router_main.valid?.should be_true
    end

    describe "with net mask 255.0.0.0 and ip address 10.1.1.1" do
      before(:each) do
        @router_main.stub!(:int_inf).and_return(
          build_router_interface(
            :ip_address => '10.1.1.1',
            :ip_mask => '255.0.0.0'))
      end

      it "should return subnet" do
        @router_main.int_inf.subnet.should == '10.0.0.0'
      end

      it "should return broadcast" do
        @router_main.int_inf.broadcast.should == '10.255.255.255'
      end
    end
    
    describe "with net mask 255.255.0.0 and ip address 10.1.1.1" do
      before(:each) do
        @router_main.stub!(:int_inf).and_return(
          build_router_interface(
            :ip_address => '10.1.1.1',
            :ip_mask => '255.255.0.0'))
      end

      it "should return subnet" do
        @router_main.int_inf.subnet.should == '10.1.0.0'
      end

      it "should return broadcast" do
        @router_main.int_inf.broadcast.should == '10.1.255.255'
      end
    end

    describe "with net mask 255.255.255.0 and ip address 192.168.1.101" do
      before(:each) do
        @router_main.stub!(:int_inf).and_return(
          build_router_interface(
            :ip_address => '192.168.1.101',
            :ip_mask => '255.255.255.0'))
      end

      it "should return subnet" do
        @router_main.int_inf.subnet.should == '192.168.1.0'
      end

      it "should return broadcast" do
        @router_main.int_inf.broadcast.should == '192.168.1.255'
      end
    end
  end
end
