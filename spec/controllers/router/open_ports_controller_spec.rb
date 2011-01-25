require 'spec_helper'

describe Router::OpenPortsController do
  fixtures :users
  render_views

  def mock_open_port(stubs={})
    @mock_open_port ||= mock_model(Router::Rule::OpenPort, stubs).as_null_object
  end

  before(:each) do
    login_as(:quentin)
    stub_shell_commands
  end

  describe "GET index" do
    it "assigns all open_ports as @open_ports" do
      Router::Rule::OpenPort.stub(:all) { [mock_open_port] }
      get :index
      assigns(:open_ports).should eq([mock_open_port])
    end
  end

  describe "GET show" do
    it "assigns the requested open_port as @open_port" do
      Router::Rule::OpenPort.stub(:find).with("37") { mock_open_port }
      get :show, :id => "37"
      assigns(:open_port).should be(mock_open_port)
    end
  end

  describe "GET new" do
    it "assigns a new open_port as @open_port" do
      Router::Rule::OpenPort.stub(:new) { mock_open_port }
      get :new
      assigns(:open_port).should be(mock_open_port)
    end
  end

  describe "GET edit" do
    it "assigns the requested open_port as @open_port" do
      Router::Rule::OpenPort.stub(:find).with("37") { mock_open_port }
      get :edit, :id => "37"
      assigns(:open_port).should be(mock_open_port)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created open_port as @open_port" do
        Router::Rule::OpenPort.stub(:new).with({'these' => 'params'}) { mock_open_port(:save => true) }
        post :create, :open_port => {'these' => 'params'}
        assigns(:open_port).should be(mock_open_port)
      end

      it "redirects to the created open_port" do
        Router::Rule::OpenPort.stub(:new) { mock_open_port(:save => true) }
        post :create, :open_port => {}
        response.should redirect_to(router_open_port_url(mock_open_port))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved open_port as @open_port" do
        Router::Rule::OpenPort.stub(:new).with({'these' => 'params'}) { mock_open_port(:save => false) }
        post :create, :open_port => {'these' => 'params'}
        assigns(:open_port).should be(mock_open_port)
      end

      it "re-renders the 'new' template" do
        Router::Rule::OpenPort.stub(:new) { mock_open_port(:save => false) }
        post :create, :open_port => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested open_port" do
        Router::Rule::OpenPort.stub(:find).with("37") { mock_open_port }
        mock_open_port.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :open_port => {'these' => 'params'}
      end

      it "assigns the requested open_port as @open_port" do
        Router::Rule::OpenPort.stub(:find) { mock_open_port(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:open_port).should be(mock_open_port)
      end

      it "redirects to the open_port" do
        Router::Rule::OpenPort.stub(:find) { mock_open_port(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(router_open_port_url(mock_open_port))
      end
    end

    describe "with invalid params" do
      it "assigns the open_port as @open_port" do
        Router::Rule::OpenPort.stub(:find) { mock_open_port(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:open_port).should be(mock_open_port)
      end

      it "re-renders the 'edit' template" do
        Router::Rule::OpenPort.stub(:find) { mock_open_port(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested open_port" do
      Router::Rule::OpenPort.stub(:find).with("37") { mock_open_port }
      mock_open_port.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the router_open_ports list" do
      Router::Rule::OpenPort.stub(:find) { mock_open_port }
      delete :destroy, :id => "1"
      response.should redirect_to(router_open_ports_url)
    end
  end

end
