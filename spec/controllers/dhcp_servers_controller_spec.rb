require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DhcpServersController do
  fixtures :users

  before(:each) do
    login_as(:quentin)
  end

  def mock_dhcp_server options={}
    mock_model(DhcpServer, {
                 :domain_name => 'test.host.net', 
                 :domain_name_servers => ['1.1.1.1','2.2.2.2'],
                 :subnet_mask => '255.0.0.0',
                 :default_lease_time => 8090,
                 :max_lease_time => 12390,
                 :subnet => '10.0.0.0',
                 :range_from => '10.5.5.20',
                 :range_to => '10.5.5.40',
                 :broadcast_address => '10.255.255.255',
                 :router => '10.1.1.1',
               }.merge(options))
  end

  describe "handling GET /dhcp_servers" do

    before(:each) do
      @dhcp_server = build_dhcp_server
      DhcpServer.stub!(:find).and_return(@dhcp_server)
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
  
    it "should find all dhcp_servers" do
      DhcpServer.should_receive(:find).with(:first).and_return(@dhcp_server)
      do_get
    end
  
    it "should assign the found dhcp_servers for the view" do
      do_get
      assigns[:dhcp_server].should == @dhcp_server
    end
  end

  describe "handling PUT /dhcp_servers/1" do

    before(:each) do
      @dhcp_server = mock_model(DhcpServer, :to_param => "1")
      DhcpServer.stub!(:find).and_return(@dhcp_server)
    end
    
    describe "with successful update" do

      def do_put
        @dhcp_server.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the dhcp_server requested" do
        DhcpServer.should_receive(:find).with(:first).and_return(@dhcp_server)
        do_put
      end

      it "should update the found dhcp_server" do
        do_put
        assigns(:dhcp_server).should equal(@dhcp_server)
      end

      it "should assign the found dhcp_server for the view" do
        do_put
        assigns(:dhcp_server).should equal(@dhcp_server)
      end

      it "should redirect to the dhcp_server" do
        do_put
        response.should redirect_to(dhcp_servers_url)
      end

    end
    
    describe "with failed update" do

      def do_put
        @dhcp_server.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('index')
      end

    end
  end
end
