class PeersController < ApplicationController
  def index
    @peers = RTorrent::Item.new(params[:torrent_id]).peers
  end
end
