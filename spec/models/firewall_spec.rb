require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Firewall do
  before(:each) do
    @firewall = Firewall.new :lan => build_local_network
  end

  it "should be valid" do
    @firewall.should be_valid
  end
  
  it "should save iptables rules in tmp files" do
    ShellCommand.should_receive(:ip_tables_save).and_return('test string')
    @firewall.write_tmp_file
    File.exist?(@firewall.dest_path).should be_true
    File.delete(@firewall.dest_path)
  end
end
