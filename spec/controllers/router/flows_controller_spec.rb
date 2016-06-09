require 'rails_helper'

describe Router::FlowsController do
  fixtures :users
  render_views

  let(:rule_flow) do
    build_model(Router::Rule::Flow, net_type: 'ext', id: 37)
  end

  before(:each) do
    login_as(:quentin)
    stub_shell_commands
    rule_flow
  end

  describe "GET index" do
    it "assigns all router_flows as @router_flows" do
      allow(Router::Rule::Flow).to receive(:all) { [rule_flow] }
      get :index
      expect(assigns(:router_flows)).to eq([rule_flow])
    end
  end

  describe "GET new" do
    it "assigns a new flow as @flow" do
      get :new
      expect(assigns(:router_flow)).to be_kind_of(rule_flow.class)
    end
  end

  describe "GET edit" do
    it "assigns the requested flow as @flow" do
      allow(Router::Rule::Flow).to receive(:find).with("37") { rule_flow }
      get :edit, :id => "37"
      expect(assigns(:router_flow)).to be(rule_flow)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created flow as @flow" do
        post :create, :router_flow => {'net_type' => 'ext'}
        expect(assigns(:router_flow)).to be_kind_of(rule_flow.class)
      end

      it "redirects to the created flow" do
        post :create, :router_flow => {}
        expect(response).to redirect_to(router_flows_url)
      end
    end

    describe "with invalid params" do
      before do
        expect(Router::Rule::Flow).to receive(:new).with({}) { rule_flow }
        expect(rule_flow).to receive(:save) { false }
      end

      it "assigns a newly created but unsaved flow as @flow" do
        post :create, :router_flow => {}
        expect(assigns(:router_flow)).to be(rule_flow)
      end

      it "re-renders the 'new' template" do
        post :create, :router_flow => {}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    before do
      allow(Router::Rule::Flow).to receive(:find).with("37") { rule_flow }
    end

    describe "with valid params" do
      it "updates the requested flow" do
        expect(rule_flow).to receive(:update_attributes).with({'net_type' => 'ext'})
        put :update, :id => "37", :router_flow => {'net_type' => 'ext'}
      end

      it "assigns the requested flow as @flow" do
        expect(rule_flow).to receive(:update_attributes) { true }
        put :update, :id => "37"
        expect(assigns(:router_flow)).to be(rule_flow)
      end

      it "redirects to the flow" do
        expect(rule_flow).to receive(:update_attributes) { true }
        put :update, :id => "37"
        expect(response).to redirect_to(router_flows_url)
      end
    end

    describe "with invalid params" do
      before do
        expect(rule_flow).to receive(:update_attributes) { false }
      end

      it "assigns the flow as @flow" do
        put :update, :id => "37"
        expect(assigns(:router_flow)).to be(rule_flow)
      end

      it "re-renders the 'edit' template" do
        put :update, :id => "37"
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before do
      allow(Router::Rule::Flow).to receive(:find).with("37") { rule_flow }
    end

    it "destroys the requested flow" do
      expect(rule_flow).to receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the router_flows list" do
      delete :destroy, :id => "37"
      expect(response).to redirect_to(router_flows_url)
    end
  end

end
