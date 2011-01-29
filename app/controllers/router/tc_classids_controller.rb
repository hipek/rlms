class Router::TcClassidsController < Router::BaseController
  def index
    new
    @tc_classids = Router::Tc::Classid.all(:order => 'net_type DESC, prio ASC')
  end

  def new
    @tc_classid = Router::Tc::Classid.new
  end

  def edit
    @tc_classid = Router::Tc::Classid.find(params[:id])
  end
  
  def create
    @tc_classid = Router::Tc::Classid.new(params[:tc_classid])

    respond_to do |format|
      if @tc_classid.save
        format.html { redirect_to(router_tc_classids_url, :notice => 'Classid was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def update
    @tc_classid = Router::Tc::Classid.find(params[:id])

    respond_to do |format|
      if @tc_classid.update_attributes(params[:tc_classid])
        format.html { redirect_to(router_tc_classids_url, :notice => 'Classid was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    @tc_classid = Router::Tc::Classid.find(params[:id])
    @tc_classid.destroy

    respond_to do |format|
      format.html { redirect_to(router_tc_classids_url) }
    end
  end
end
