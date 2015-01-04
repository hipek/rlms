require 'rails_helper'

describe Torrent::ItemsController do
  fixtures :users, :groups, :group_memberships
  render_views

  before(:each) do
    login_as(:admin)
    #add_permission groups(:administrator), "admin"
    allow(RTorrent::Client).to receive(:download_rate).and_return(100)
    allow(RTorrent::Client).to receive(:down_rate).and_return(100)
    allow(RTorrent::Client).to receive(:upload_rate).and_return(100)
    allow(RTorrent::Client).to receive(:up_rate).and_return(100)
  end

  
  def mock_torrent(stubs={})
    @mock_torrent ||= mock_model('RTorrentItem', {
      :name => 'name',
      :bytes => 1231,
      :bytes_completed => 10,
      :local_id => 'asdfa',
      :percent_complete => 60,
      :created_at => Time.now,
      :status => 'done',
      :message => 'ok',
      :down_rate => 10,
      :up_rate => 10,
      :directory => '/tmp/rtorrent',
      :path => '/aaa/bbb',
      :display_priority => 2,
      :conn_type => 'normal',
      :time_left => '10',
      :torrent_url => '',
    }.merge(stubs))
  end
  
  describe "responding to GET index" do

    it "should expose all torrents as @torrents" do
      RTorrent::Client.should_receive(:items).and_return([mock_torrent])
      get :index
      assigns[:torrents].should == [mock_torrent]
    end

  end

  describe "responding to GET show" do

    it "should expose the requested torrent as @torrent" do
      RTorrent::Item.should_receive(:new).with("37").and_return(mock_torrent)
      get :show, :id => "37"
      assigns[:torrent].should equal(mock_torrent)
    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new torrent as @torrent" do
      RTorrent::Item.should_receive(:new).and_return(mock_torrent)
      get :new
      assigns[:torrent].should equal(mock_torrent)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should redirect to the created torrent" do
        RTorrent::Client.should_receive(:upload).with(['aaa']).and_return(true)
        post :create, torrent:{:torrents => 'aaa'}
        response.should redirect_to(new_torrent_item_url)
      end
      
    end
    
    # describe "with invalid params" do
    # 
    #   it "should expose a newly created but unsaved torrent as @torrent" do
    #     allow(RTorrent::Item).to receive(:new).with({'these' => 'params'}).and_return(mock_torrent(:save => false))
    #     post :create, :torrent => {:these => 'params'}
    #     assigns(:torrent).should equal(mock_torrent)
    #   end
    # 
    #   it "should re-render the 'new' template" do
    #     allow(RTorrent::Item).to receive(:new).and_return(mock_torrent(:save => false))
    #     post :create, :torrent => {}
    #     response.should render_template('new')
    #   end
    #   
    # end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested torrent" do
        RTorrent::Client.should_receive(:items).and_return(@torrents = [mock_torrent(:id => 'aaaa')])
        mock_torrent.should_receive(:send).with(:close)
        put :update, :id => "0", :hashes => ['aaaa'], :commit => "Close"
        assigns(:torrents).should == (@torrents)
      end

      it "should redirect to the torrent" do
        RTorrent::Client.should_receive(:items).and_return(@torrents = [mock_torrent(:id => 'aaaa')])
        put :update, :id => "0", :hashes => [], :commit => 'Stop'
        response.should redirect_to(torrent_items_url)
      end

    end
    
    # describe "with invalid params" do
    # 
    #   it "should update the requested torrent" do
    #     RTorrent::Item.should_receive(:find).with("37").and_return(mock_torrent)
    #     mock_torrent.should_receive(:update_attributes).with({'these' => 'params'})
    #     put :update, :id => "37", :torrent => {:these => 'params'}
    #   end
    # 
    #   it "should expose the torrent as @torrent" do
    #     allow(RTorrent::Item).to receive(:find).and_return(mock_torrent(:update_attributes => false))
    #     put :update, :id => "1"
    #     assigns(:torrent).should equal(mock_torrent)
    #   end
    # 
    #   it "should re-render the 'edit' template" do
    #     allow(RTorrent::Item).to receive(:find).and_return(mock_torrent(:update_attributes => false))
    #     put :update, :id => "1"
    #     response.should render_template('edit')
    #   end
    # 
    # end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested torrent" do
      RTorrent::Item.should_receive(:new).with("37").and_return(mock_torrent)
      mock_torrent.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the torrents list" do
      allow(RTorrent::Item).to receive(:new).and_return(mock_torrent(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(torrent_items_url)
    end

  end
end
