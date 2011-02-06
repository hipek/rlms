require 'spec_helper'

describe Torrent::FilesController do
  fixtures :users, :groups, :group_memberships
  render_views

  before(:each) do
    login_as(:admin)
    #add_permission groups(:administrator), "admin"
  end

  describe "GET 'index'" do
    it "should be successful" do
      RTorrent::Item.stub!(:new).with('a').and_return(mock('Items', :files => []))
      get 'index', :item_id => 'a'
      response.should be_success
    end
  end
end
