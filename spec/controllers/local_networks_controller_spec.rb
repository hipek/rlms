require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LocalNetworksController do
  fixtures :users, :groups, :group_memberships
  render_views

  before(:each) do
    login_as(:admin)
    add_permission groups(:administrator), "networks"
    stub_shell_commands
    ShellCommand.stub!(:read_interfaces).and_return(['eth1', 'eth0'])
  end

  describe "handling GET /local_networks" do

    before(:each) do
      @local_network = build_model(LocalNetwork)
      LocalNetwork.stub!(:find).and_return(@local_network)
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
  
    it "should find all local_networks" do
      LocalNetwork.should_receive(:find).with(:first).and_return(@local_network)
      do_get
    end
  
    it "should assign the found local_networks for the view" do
      do_get
      assigns[:local_network].should == @local_network
    end
  end

  describe "handling PUT /local_networks/1" do

    before(:each) do
      @local_network = build_model(LocalNetwork, :id => "1")
      LocalNetwork.stub!(:find).and_return(@local_network)
    end
    
    describe "with successful update" do

      def do_put
        @local_network.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the local_network requested" do
        LocalNetwork.should_receive(:find).with(:first).and_return(@local_network)
        do_put
      end

      it "should update the found local_network" do
        do_put
        assigns(:local_network).should equal(@local_network)
      end

      it "should redirect to the local_network" do
        do_put
        response.should redirect_to(local_networks_url)
      end

    end
    
    describe "with failed update" do

      def do_put
        @local_network.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('index')
      end

    end
  end
end
