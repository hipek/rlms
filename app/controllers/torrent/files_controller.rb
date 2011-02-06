class Torrent::FilesController < Torrent::BaseController
  def index
    @files = RTorrent::Item.new(params[:item_id]).files
  end

  def update
    files = RTorrent::Item.new(params[:item_id]).files
    params[:priorities].each do |i, prio|
      files[i.to_i].set_priority i.to_i, prio
    end
    redirect_to torrent_files_path(params[:item_id])
  end
end
