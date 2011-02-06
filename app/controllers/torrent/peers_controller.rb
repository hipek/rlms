class Torrent::PeersController < Torrent::BaseController
  def index
    @peers = RTorrent::Item.new(params[:item_id]).peers
  end
end
