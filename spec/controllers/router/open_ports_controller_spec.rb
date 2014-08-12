require 'spec_helper'

describe Router::OpenPortsController do
  fixtures :users
  render_views

  let(:open_port) do
    build_model(Router::Rule::OpenPort, id: 37)
  end

  before(:each) do
    login_as(:quentin)
    stub_shell_commands
    open_port
  end

  describe "GET index" do
    it "assigns all open_ports as @open_ports" do
      expect(Router::Rule::OpenPort).to receive(:all) { [open_port] }
      get :index
      assigns(:open_ports).should eq([open_port])
    end
  end

  describe "GET show" do
    it "assigns the requested open_port as @open_port" do
      expect(Router::Rule::OpenPort).to receive(:find).with("37") { open_port }
      get :show, :id => "37"
      assigns(:open_port).should be(open_port)
    end
  end

  describe "GET new" do
    it "assigns a new open_port as @open_port" do
      get :new
      assigns(:open_port).should be_kind_of(open_port.class)
    end
  end

  describe "GET edit" do
    it "assigns the requested open_port as @open_port" do
      expect(Router::Rule::OpenPort).to receive(:find).with("37") { open_port }
      get :edit, :id => "37"
      expect(assigns(:open_port)).to eql(open_port)
    end
  end

  describe "POST create" do
    before do
      expect(Router::Rule::OpenPort).to receive(:new).with({'these' => 'params'}) { open_port }
    end

    describe "with valid params" do
      it "assigns a newly created open_port as @open_port" do
        post :create, :open_port => {'these' => 'params'}
        assigns(:open_port).should be(open_port)
      end

      it "redirects to the created open_port" do
        expect(open_port).to receive(:save) { true }
        post :create, :open_port => {'these' => 'params'}
        response.should redirect_to(router_open_port_url(open_port))
      end
    end

    describe "with invalid params" do
      before do
        expect(open_port).to receive(:save) { false }
      end

      it "assigns a newly created but unsaved open_port as @open_port" do
        post :create, :open_port => {'these' => 'params'}
        assigns(:open_port).should be(open_port)
      end

      it "re-renders the 'new' template" do
        post :create, :open_port => {'these' => 'params'}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    before do
      expect(Router::Rule::OpenPort).to receive(:find).with("37") { open_port }
    end

    describe "with valid params" do
      it "updates the requested open_port" do
        expect(open_port).to receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :open_port => {'these' => 'params'}
      end

      it "assigns the requested open_port as @open_port" do
        put :update, :id => "37"
        assigns(:open_port).should be(open_port)
      end

      it "redirects to the open_port" do
        expect(open_port).to receive(:update_attributes) { true }
        put :update, :id => "37"
        response.should redirect_to(router_open_port_url(open_port))
      end
    end

    describe "with invalid params" do
      before do
        expect(open_port).to receive(:update_attributes) { false }
      end

      it "assigns the open_port as @open_port" do
        put :update, :id => "37"
        assigns(:open_port).should be(open_port)
      end

      it "re-renders the 'edit' template" do
        put :update, :id => "37"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before do
      expect(Router::Rule::OpenPort).to receive(:find) { open_port }
    end

    it "destroys the requested open_port" do
      open_port.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the router_open_ports list" do
      delete :destroy, :id => "1"
      response.should redirect_to(router_open_ports_url)
    end
  end

end
