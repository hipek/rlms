require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FirewallsController do
  fixtures :users
  render_views

  before(:each) do
    login_as(:quentin)
    controller.stub!(:current_lan).and_return(@ln = build_local_network)
  end

  describe "handling GET /firewalls" do

    before(:each) do
      @firewall = build_model(Firewall, :id => 122)
      @ln.stub_chain(:firewalls, :find).with(:all).and_return([@firewall])
    end
  
    def do_get
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end

    it "should assign the found firewalls for the view" do
      do_get
      assigns[:firewalls].should == [@firewall]
    end
  end

  describe "handling GET /firewalls/1" do

    before(:each) do
      @firewall = build_model(Firewall, :id => 1211)
      @ln.stub_chain(:firewalls, :find_by_id).and_return(@firewall)
    end
  
    def do_get
      get :show, :id => @firewall.id
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
  
    it "should find the firewall requested" do
      do_get
    end
  
    it "should assign the found firewall for the view" do
      do_get
      assigns[:firewall].should equal(@firewall)
    end
  end

  describe "handling GET /firewalls/new" do

    before(:each) do
      @firewall = build_model(Firewall, :lan => build_local_network, :start_date => Time.now)
      Firewall.stub!(:new).and_return(@firewall)
    end
  
    def do_get
      get :new
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render new template" do
      do_get
      response.should render_template('new')
    end
  
    it "should create an new firewall" do
      Firewall.should_receive(:new).and_return(@firewall)
      do_get
    end
  
    it "should not save the new firewall" do
      @firewall.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new firewall for the view" do
      do_get
      assigns[:firewall].should equal(@firewall)
    end
  end

  describe "handling GET /firewalls/1/edit" do

    before(:each) do
      @firewall = build_model(Firewall)
      @ln.stub_chain(:firewalls, :find_by_id).and_return(@firewall)
      @firewall.stub!(:lan).and_return(@ln)
    end
  
    def do_get
      get :edit, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should find the firewall requested" do
      do_get
    end
  
    it "should assign the found Firewall for the view" do
      do_get
      assigns[:firewall].should equal(@firewall)
    end
  end

  describe "handling POST /firewalls" do
    
    describe "with successful save" do
  
      def do_post
        post :create, :firewall => {}
      end
  
      it "should redirect to the new firewall" do
        do_post
        response.should redirect_to(firewall_url(assigns(:firewall)))
      end
      
    end
    
    describe "with failed save" do

      before(:each) do
        @firewall = build_model(Firewall, :id => 1)
        @firewall.stub!(:lan).and_return(@ln)
        @ln.stub_chain(:firewalls, :build).and_return(@firewall)
      end

      def do_post
        @firewall.should_receive(:save).and_return(false)
        post :create, :firewall => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /firewalls/1" do

    before(:each) do
      @firewall = build_model(Firewall, :id => 12)
      @firewall.stub!(:lan).and_return(@ln)
      @ln.stub_chain(:firewalls, :find_by_id).and_return(@firewall)
    end
    
    describe "with successful update" do

      def do_put
        @firewall.should_receive(:update_attributes).and_return(true)
        put :update, :id => 12
      end

      it "should find the firewall requested" do
        do_put
      end

      it "should update the found firewall" do
        do_put
        assigns(:firewall).should equal(@firewall)
      end

      it "should redirect to the firewall" do
        do_put
        response.should redirect_to(firewall_url(@firewall))
      end

    end
    
    describe "with failed update" do

      def do_put
        @firewall.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /firewalls/1" do

    before(:each) do
      @firewall = build_model(Firewall)
      @firewall.stub!(:destroy).and_return(true)
      @ln.stub_chain(:firewalls, :find_by_id).and_return(@firewall)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the firewall requested" do
      do_delete
    end
  
    it "should call destroy on the found firewall" do
      @firewall.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the firewalls list" do
      do_delete
      response.should redirect_to(firewalls_url)
    end
  end
end
