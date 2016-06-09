require 'rails_helper'

describe FwSnat do
  let(:fw_snat) { FwSnat.new }

  it "should be valid" do
    expect(fw_snat).to be_valid
  end
end
