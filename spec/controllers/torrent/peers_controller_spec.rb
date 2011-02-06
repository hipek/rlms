require 'spec_helper'

describe Torrent::PeersController do
  fixtures :users, :groups, :group_memberships
  render_views

  before(:each) do
    login_as(:admin)
  end

  describe "GET 'index'" do
    it "should be successful" do
      RTorrent::Item.stub!(:new).with('aaa').and_return(mock('Items', :peers => []))
      get 'index', :item_id => 'aaa'
      response.should be_success
    end
  end
end
