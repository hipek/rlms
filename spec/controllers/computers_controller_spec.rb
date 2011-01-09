require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ComputersController do
  fixtures :users, :groups, :group_memberships, :computers

  before(:each) do
    login_as(:admin)
    add_permission groups(:administrator), "computers"
    add_permission groups(:administrator), "computer_delete"
    add_permission groups(:administrator), "computer_create"
    add_permission groups(:administrator), "computer_update"
    stub_shell_commands
  end

  describe "handling GET /computers" do

    before(:each) do
      @computer = mock_model(Computer)
      Computer.stub!(:find).and_return([@computer])
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

    it "should find all computers" do
      Computer.should_receive(:find).with(:all, {:order => Computer::SORT_BY_IP }).and_return([@computer])
      do_get
    end

    it "should assign the found computers for the view" do
      do_get
      assigns[:computers].should == [@computer]
    end
  end

  describe "handling GET /computers/1" do

    before(:each) do
      @computer = mock_model(Computer)
      Computer.stub!(:find).and_return(@computer)
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

    it "should find the computer requested" do
      Computer.should_receive(:find).with("1").and_return(@computer)
      do_get
    end

    it "should assign the found computer for the view" do
      do_get
      assigns[:computer].should equal(@computer)
    end
  end

  describe "handling GET /computers/1/pass" do

    before(:each) do
      @computer = mock_model(Computer)
      Computer.stub!(:find_by_id).with("1").and_return(@computer)
    end

    def do_post
      post :pass, :id => "1"
    end

    it "should be redirect" do
      @computer.should_receive(:pass).and_return(true)
      do_post
      response.should redirect_to(computers_url)
    end
    
  end  

  describe "handling GET /computers/1/block" do

    before(:each) do
      @computer = mock_model(Computer)
      Computer.stub!(:find_by_id).with("1").and_return(@computer)
    end

    def do_post
      post :block, :id => "1"
    end

    it "should be redirect" do
      @computer.should_receive(:block).and_return(true)
      do_post
      response.should redirect_to(computers_url)
    end
    
  end 
  
  describe "handling GET /computers/new" do

    before(:each) do
      @computer = mock_model(Computer, :ip_address= => nil)
      Computer.stub!(:new).and_return(@computer)
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

    it "should create an new computer" do
      Computer.should_receive(:new).and_return(@computer)
      do_get
    end

    it "should not save the new computer" do
      @computer.should_not_receive(:save)
      do_get
    end

    it "should assign the new computer for the view" do
      do_get
      assigns[:computer].should equal(@computer)
    end
  end

  describe "handling GET /computers/1/edit" do

    before(:each) do
      @computer = mock_model(Computer)
      Computer.stub!(:find).and_return(@computer)
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

    it "should find the computer requested" do
      Computer.should_receive(:find).and_return(@computer)
      do_get
    end

    it "should assign the found Computer for the view" do
      do_get
      assigns[:computer].should equal(@computer)
    end
  end

  describe "handling POST /computers" do

    before(:each) do
      @computer = mock_model(Computer, :to_param => "1", :new_record? => true)
      Computer.stub!(:new).and_return(@computer)
      DhcpServer.stub!(:lan).and_return(mock('lan', :find => build_dhcp_server))
    end

    describe "with successful save" do

      def do_post
        @computer.should_receive(:save).and_return(true)
        post :create, :computer => {}
      end

      it "should create a new computer" do
        Computer.should_receive(:new).with({}).and_return(@computer)
        do_post
      end

      it "should redirect to the new computer" do
        do_post
        response.should redirect_to(computers_url)
      end

    end

    describe "with failed save" do

      def do_post
        @computer.should_receive(:save).and_return(false)
        post :create, :computer => {}
      end

      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end

    end
  end

  describe "handling PUT /computers/1" do

    before(:each) do
      @computer = mock_model(Computer, :to_param => "1")
      Computer.stub!(:find).and_return(@computer)
      DhcpServer.stub!(:lan).and_return(mock('lan', :find => build_dhcp_server))
      Computer.stub!(:all_for_dhcpd).and_return([build_computer])
    end

    describe "with successful update" do

      def do_put
        @computer.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the computer requested" do
        Computer.should_receive(:find).with("1").and_return(@computer)
        do_put
      end

      it "should update the found computer" do
        do_put
        assigns(:computer).should equal(@computer)
      end

      it "should assign the found computer for the view" do
        do_put
        assigns(:computer).should equal(@computer)
      end

      it "should redirect to the computer" do
        do_put
        response.should redirect_to(computers_url)
      end

    end

    describe "with failed update" do

      def do_put
        @computer.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /computers/1" do

    before(:each) do
      @computer = mock_model(Computer, :destroy => true)
      Computer.stub!(:find).and_return(@computer)
    end

    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the computer requested" do
      Computer.should_receive(:find).with("1").and_return(@computer)
      do_delete
    end

    it "should call destroy on the found computer" do
      @computer.should_receive(:destroy)
      do_delete
    end

    it "should redirect to the computers list" do
      do_delete
      response.should redirect_to(computers_url)
    end
  end
end
