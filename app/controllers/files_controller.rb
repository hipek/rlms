class FilesController < ApplicationController
  def index
    @files = RTorrent::Item.new(params[:torrent_id]).files
  end

  def update
    files = RTorrent::Item.new(params[:torrent_id]).files
    params[:priorities].each do |i, prio|
      files[i.to_i].set_priority i.to_i, prio
    end
    redirect_to torrent_files_path(params[:torrent_id])
  end
end
