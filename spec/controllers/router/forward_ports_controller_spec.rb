require 'spec_helper'

describe Router::ForwardPortsController do
  fixtures :users
  render_views

  def mock_forward_port(stubs={})
    @mock_forward_port ||= mock_model(Router::Rule::ForwardPort, stubs).as_null_object
  end

  before(:each) do
    login_as(:quentin)
    stub_shell_commands
  end

  describe "GET index" do
    it "assigns all forward_ports as @forward_ports" do
      Router::Rule::ForwardPort.stub(:all) { [mock_forward_port] }
      get :index
      assigns(:forward_ports).should eq([mock_forward_port])
    end
  end

  describe "GET show" do
    it "assigns the requested forward_port as @forward_port" do
      Router::Rule::ForwardPort.stub(:find).with("37") { mock_forward_port }
      get :show, :id => "37"
      assigns(:forward_port).should be(mock_forward_port)
    end
  end

  describe "GET new" do
    it "assigns a new forward_port as @forward_port" do
      Router::Rule::ForwardPort.stub(:new) { mock_forward_port }
      get :new
      assigns(:forward_port).should be(mock_forward_port)
    end
  end

  describe "GET edit" do
    it "assigns the requested forward_port as @forward_port" do
      Router::Rule::ForwardPort.stub(:find).with("37") { mock_forward_port }
      get :edit, :id => "37"
      assigns(:forward_port).should be(mock_forward_port)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created forward_port as @forward_port" do
        Router::Rule::ForwardPort.stub(:new).with({'these' => 'params'}) { mock_forward_port(:save => true) }
        post :create, :forward_port => {'these' => 'params'}
        assigns(:forward_port).should be(mock_forward_port)
      end

      it "redirects to the created forward_port" do
        Router::Rule::ForwardPort.stub(:new) { mock_forward_port(:save => true) }
        post :create, :forward_port => {}
        response.should redirect_to(router_forward_port_url(mock_forward_port))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved forward_port as @forward_port" do
        Router::Rule::ForwardPort.stub(:new).with({'these' => 'params'}) { mock_forward_port(:save => false) }
        post :create, :forward_port => {'these' => 'params'}
        assigns(:forward_port).should be(mock_forward_port)
      end

      it "re-renders the 'new' template" do
        Router::Rule::ForwardPort.stub(:new) { mock_forward_port(:save => false) }
        post :create, :forward_port => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested forward_port" do
        Router::Rule::ForwardPort.stub(:find).with("37") { mock_forward_port }
        mock_forward_port.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :forward_port => {'these' => 'params'}
      end

      it "assigns the requested forward_port as @forward_port" do
        Router::Rule::ForwardPort.stub(:find) { mock_forward_port(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:forward_port).should be(mock_forward_port)
      end

      it "redirects to the forward_port" do
        Router::Rule::ForwardPort.stub(:find) { mock_forward_port(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(router_forward_port_url(mock_forward_port))
      end
    end

    describe "with invalid params" do
      it "assigns the forward_port as @forward_port" do
        Router::Rule::ForwardPort.stub(:find) { mock_forward_port(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:forward_port).should be(mock_forward_port)
      end

      it "re-renders the 'edit' template" do
        Router::Rule::ForwardPort.stub(:find) { mock_forward_port(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested forward_port" do
      Router::Rule::ForwardPort.stub(:find).with("37") { mock_forward_port }
      mock_forward_port.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the forward_ports list" do
      Router::Rule::ForwardPort.stub(:find) { mock_forward_port }
      delete :destroy, :id => "1"
      response.should redirect_to(router_forward_ports_url)
    end
  end

end
