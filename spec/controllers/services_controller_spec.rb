require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ServicesController do
  fixtures :users
  render_views

  before(:each) do
    login_as(:quentin)
  end

  describe "handling GET /services" do

    before(:each) do
      @service = build_model(Service, :id => 1)
      Service.stub!(:find).and_return([@service])
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
  
    it "should find all services" do
      Service.should_receive(:find).with(:all).and_return([@service])
      do_get
    end
  
    it "should assign the found services for the view" do
      do_get
      assigns[:services].should == [@service]
    end
  end

  describe "handling GET /services/1" do

    before(:each) do
      @service = build_model(Service, :id => 1)
      Service.stub!(:find).and_return(@service)
    end
  
    def do_get
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
  
    it "should find the service requested" do
      Service.should_receive(:find).with("1").and_return(@service)
      do_get
    end
  
    it "should assign the found service for the view" do
      do_get
      assigns[:service].should equal(@service)
    end
  end

  describe "handling GET /services/new" do

    before(:each) do
      @service = build_model(Service)
      Service.stub!(:new).and_return(@service)
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
  
    it "should create an new service" do
      Service.should_receive(:new).and_return(@service)
      do_get
    end
  
    it "should not save the new service" do
      @service.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new service for the view" do
      do_get
      assigns[:service].should equal(@service)
    end
  end

  describe "handling GET /services/1/edit" do

    before(:each) do
      @service = build_model(Service, :id => 1)
      Service.stub!(:find).and_return(@service)
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
  
    it "should find the service requested" do
      Service.should_receive(:find).and_return(@service)
      do_get
    end
  
    it "should assign the found Service for the view" do
      do_get
      assigns[:service].should equal(@service)
    end
  end

  describe "handling POST /services" do

    before(:each) do
      @service = build_model(Service, :id => 1)
      Service.stub!(:new).and_return(@service)
    end
    
    describe "with successful save" do
  
      def do_post
        @service.should_receive(:save).and_return(true)
        post :create, :service => {}
      end
  
      it "should create a new service" do
        Service.should_receive(:new).with({}).and_return(@service)
        do_post
      end

      it "should redirect to the new service" do
        do_post
        response.should redirect_to(services_url)
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @service.should_receive(:save).and_return(false)
        post :create, :service => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /services/1" do

    before(:each) do
      @service = build_model(Service, :id => 1)
      Service.stub!(:find).and_return(@service)
    end
    
    describe "with successful update" do

      def do_put
        @service.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the service requested" do
        Service.should_receive(:find).with("1").and_return(@service)
        do_put
      end

      it "should update the found service" do
        do_put
        assigns(:service).should equal(@service)
      end

      it "should assign the found service for the view" do
        do_put
        assigns(:service).should equal(@service)
      end

      it "should redirect to the service" do
        do_put
        response.should redirect_to(services_url)
      end

    end
    
    describe "with failed update" do

      def do_put
        @service.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /services/1" do

    before(:each) do
      @service = build_model(Service)
      @service.stub!(:destroy).and_return(true)
      Service.stub!(:find).and_return(@service)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the service requested" do
      Service.should_receive(:find).with("1").and_return(@service)
      do_delete
    end
  
    it "should call destroy on the found service" do
      @service.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the services list" do
      do_delete
      response.should redirect_to(services_url)
    end
  end

  describe "handling POST /services/dupa/find" do

    before(:each) do
      @service = build_service
      stub_shell_commands
    end
  
    def do_post
      post :find, :id => "dhcp", :type => 'config'
    end

    it "should find the service requested" do
      do_post
    end
  end
end
