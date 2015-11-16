require 'rails_helper'

describe Router::Computer do
  let(:computer) do
    build_router_computer
  end

  it "should validate mac address entry" do
    computer = build_router_computer :mac_address => "10-12;13:af.dc,ag"
    expect(computer).not_to be_valid
  end

  it "should be valid" do
    expect(computer).to be_valid
  end
  
  it "should save valid mac address" do
    computer = build_router_computer :mac_address => "10-12;13:af.dc,ab"
    computer.save!
    expect(computer.mac_address).to eq "10:12:13:AF:DC:AB"
  end

  it "should have name without spaces" do
    expect(computer.valid_name).to eq 'it_a_cool_name'
  end
  
  it "should return next free IP" do
    computer.ip_address = "10.5.5.21"
    computer.save!
    computer2 = build_router_computer :ip_address => "10.5.5.15", :mac_address => "10:12:13:14:15:16"
    computer2.save!
    expect(Router::Computer.next_ip).to eq "10.5.5.22"
  end
end
