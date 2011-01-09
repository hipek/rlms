require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FilesController do
  fixtures :users, :groups, :group_memberships

  before(:each) do
    login_as(:admin)
    #add_permission groups(:administrator), "admin"
  end

  describe "GET 'index'" do
    it "should be successful" do
      RTorrent::Item.stub!(:new).with('a').and_return(mock('Items', :files => []))
      get 'index', :torrent_id => 'a'
      response.should be_success
    end
  end
end
