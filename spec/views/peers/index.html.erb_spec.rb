require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/peers/index" do
  before(:each) do
    assigns[:peers] = [mock_model(RTorrent::Peer, :up_total => 1, :down_total => 2, :peer_total => 3, :address => '', :up_rate => 0, :down_rate => 0, :completed_percent => 0, :client_version => 'as')]
    render 'peers/index'
  end
  
  it "should tell you where to find the file" do
    response.capture(:col2).should have_tag('table')
  end
end
