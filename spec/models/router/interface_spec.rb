require 'rails_helper'

describe Router::Interface do
  describe "subnet_mask" do
    let(:interface) do
      build_router_interface(ip_address: '10.1.1.1')
    end

    it "should return subnet mask" do
      interface.ip_mask = '255.0.0.0'
      expect(interface.subnet_short_mask).to eq '8'
    end

    it "should return subnet mask for 2" do
      interface.ip_mask = '255.255.0.0'
      expect(interface.subnet_short_mask).to eq '16'
    end

    it "should return subnet mask for 3" do
      interface.ip_mask = '255.255.255.0'
      expect(interface.subnet_short_mask).to eq '24'
    end
  end
end
