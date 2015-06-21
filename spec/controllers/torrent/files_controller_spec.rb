require 'rails_helper'

describe Torrent::FilesController do
  fixtures :users, :groups, :group_memberships
  render_views

  before(:each) do
    login_as(:admin)
    #add_permission groups(:administrator), "admin"
  end

  describe "GET 'index'" do
    it "should be successful" do
      allow(RTorrent::Item).to receive(:new).with('a').and_return(double('Items', :files => []))
      get 'index', :item_id => 'a'
      expect(response).to be_success
    end
  end
end
