require 'rails_helper'

describe Router::ForwardPortsController do
  fixtures :users
  render_views

  let(:forward_port) do
    build_model(Router::Rule::ForwardPort, id: 37)
  end

  before(:each) do
    login_as(:quentin)
    stub_shell_commands
    forward_port
  end

  describe "GET index" do
    it "assigns all forward_ports as @forward_ports" do
      expect(Router::Rule::ForwardPort).to receive(:all) { [forward_port] }
      get :index
      expect(assigns(:forward_ports)).to eq([forward_port])
    end
  end

  describe "GET new" do
    it "assigns a new forward_port as @forward_port" do
      expect(Router::Rule::ForwardPort).to receive(:new) { forward_port }
      get :new
      expect(assigns(:forward_port)).to be(forward_port)
    end
  end

  describe "GET edit" do
    it "assigns the requested forward_port as @forward_port" do
      expect(Router::Rule::ForwardPort).to receive(:find).with("37") { forward_port }
      get :edit, :id => "37"
      expect(assigns(:forward_port)).to be(forward_port)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created forward_port as @forward_port" do
        expect(Router::Rule::ForwardPort).to receive(:new).with({'these' => 'params'}) { forward_port }
        post :create, :forward_port => {'these' => 'params'}
        expect(assigns(:forward_port)).to be(forward_port)
      end

      it "redirects to the created forward_port" do
        expect(Router::Rule::ForwardPort).to receive(:new) { forward_port }
        expect(forward_port).to receive(:save) { true }
        post :create, :forward_port => {}
        expect(response).to redirect_to(router_forward_ports_url)
      end
    end

    describe "with invalid params" do
      before do
        expect(Router::Rule::ForwardPort).to receive(:new).with({}) { forward_port }
      end

      it "assigns a newly created but unsaved forward_port as @forward_port" do
        post :create, :forward_port => {}
        expect(assigns(:forward_port)).to be(forward_port)
      end

      it "re-renders the 'new' template" do
        post :create, :forward_port => {}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    before do
      expect(Router::Rule::ForwardPort).to receive(:find).with("37") { forward_port }
    end

    describe "with valid params" do
      it "updates the requested forward_port" do
        expect(forward_port).to receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :forward_port => {'these' => 'params'}
      end

      it "assigns the requested forward_port as @forward_port" do
        put :update, :id => "37"
        expect(assigns(:forward_port)).to be(forward_port)
      end

      it "redirects to the forward_port" do
        expect(forward_port).to receive(:update_attributes) { true }
        put :update, :id => "37"
        expect(response).to redirect_to(router_forward_ports_url)
      end
    end

    describe "with invalid params" do
      before do
        expect(forward_port).to receive(:update_attributes) { false }
      end

      it "assigns the forward_port as @forward_port" do
        put :update, :id => "37"
        expect(assigns(:forward_port)).to be(forward_port)
      end

      it "re-renders the 'edit' template" do
        put :update, :id => "37"
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before do
      expect(Router::Rule::ForwardPort).to receive(:find).with("37") { forward_port }
    end

    it "destroys the requested forward_port" do
      expect(forward_port).to receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the forward_ports list" do
      delete :destroy, :id => "37"
      expect(response).to redirect_to(router_forward_ports_url)
    end
  end

end
