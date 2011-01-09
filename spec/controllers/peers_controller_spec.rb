require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PeersController do
  fixtures :users, :groups, :group_memberships

  before(:each) do
    login_as(:admin)
    #add_permission groups(:administrator), "torrent"
  end

  describe "GET 'index'" do
    it "should be successful" do
      RTorrent::Item.stub!(:new).with('aaa').and_return(mock('Items', :peers => []))
      get 'index', :torrent_id => 'aaa'
      response.should be_success
    end
  end
end
