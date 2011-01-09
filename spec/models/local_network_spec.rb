require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LocalNetwork do

  before(:each) do
    @local_network = LocalNetwork.new
  end

  it "should be valid" do
    @local_network.should be_valid
  end

  it "should have fields" do
    %w[a b].each do |param|
      LocalNetwork.fields.each do |field|
        @local_network.send(:"#{field}=","#{field}_value_#{param}")
      end
      @local_network.save!
      Setting.count.should == LocalNetwork.fields.length
      @local_network = LocalNetwork.find_by_id(@local_network.id)
      LocalNetwork.fields.each do |field|
        @local_network.send(field).should == "#{field}_value_#{param}"
      end
    end
  end
end
