class Torrent::ItemsController < Torrent::BaseController
  def index
    @torrents = RTorrent::Client.items
  rescue
    @torrents = []
    @r_error = $!
  ensure
    render :update do |page|
      page.replace_html 'downloading', :partial => 'torrent', :collection => @torrents, :locals => { :hashes => params[:hashes] || [] }
      page.replace_html 'stats', :partial => 'stats'
    end if request.xhr?
  end

  def show
    @torrent = RTorrent::Item.new(params[:id])
  end

  def new
    @torrent = RTorrent::Item.new
  end

  def create
    respond_to do |format|
      flash[:notice] = 'Torrent was successfully added.' if RTorrent::Client.upload([items_params[:torrents]])
      flash[:notice] = 'Torrent url was successfully added.' if RTorrent::Client.load_start(items_params[:torrent_url])
      format.html { redirect_to(new_torrent_item_url) }
    end
  end

  def update
    @commit = params[:commit].downcase
    @hashes = params[:hashes] || []
    @torrents = RTorrent::Client.items.select{|t| @hashes.include?(t.id)  }
    
    @torrents.each{|t| 
      @commit == 'update' ? t.set_priority(params[:priority]) : t.send(:"#{@commit}") 
    }

    respond_to do |format|
      flash[:notice] = 'Torrents were successfully updated.' unless @hashes.empty?
      flash[:error] = 'No torrents selected' if @hashes.empty?
      format.html { redirect_to(torrent_items_url) }
    end
  end

  def set_rate
    up = params[:bandwidth][:up]
    down = params[:bandwidth][:down]
    RTorrent::Client.set_upload_rate up unless up.blank?
    RTorrent::Client.set_download_rate down unless down.blank?
    render :nothing => :true
  end
  
  def destroy
    @torrent = RTorrent::Item.new params[:id]
    @torrent.destroy

    respond_to do |format|
      flash[:notice] = 'Torrent has been deleted.'
      format.html { redirect_to(torrent_items_url) }
    end
  end

  protected

  def items_params
    params.require(:torrent).permit(:torrent_url, :torrents)
  end
end
