require 'spec_helper'

describe Router::FlowsController do
  fixtures :users
  render_views

  def mock_flow(stubs={})
    @mock_flow ||= mock_model(Router::Rule::Flow, {:net_type => 'ext'}.merge(stubs)).as_null_object
  end

  before(:each) do
    login_as(:quentin)
    stub_shell_commands
  end

  describe "GET index" do
    it "assigns all router_flows as @router_flows" do
      Router::Rule::Flow.stub(:all) { [mock_flow] }
      get :index
      assigns(:router_flows).should eq([mock_flow])
    end
  end

  describe "GET new" do
    it "assigns a new flow as @flow" do
      Router::Rule::Flow.stub(:new) { mock_flow }
      get :new
      assigns(:router_flow).should be(mock_flow)
    end
  end

  describe "GET edit" do
    it "assigns the requested flow as @flow" do
      Router::Rule::Flow.stub(:find).with("37") { mock_flow }
      get :edit, :id => "37"
      assigns(:router_flow).should be(mock_flow)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created flow as @flow" do
        Router::Rule::Flow.stub(:new).with({'net_type' => 'ext'}) { mock_flow(:save => true) }
        post :create, :router_flow => {'net_type' => 'ext'}
        assigns(:router_flow).should be(mock_flow)
      end

      it "redirects to the created flow" do
        Router::Rule::Flow.stub(:new) { mock_flow(:save => true) }
        post :create, :router_flow => {}
        response.should redirect_to(router_flows_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved flow as @flow" do
        Router::Rule::Flow.stub(:new).with({'net_type' => 'ext'}) { mock_flow(:save => false) }
        post :create, :router_flow => {'net_type' => 'ext'}
        assigns(:router_flow).should be(mock_flow)
      end

      it "re-renders the 'new' template" do
        Router::Rule::Flow.stub(:new) { mock_flow(:save => false) }
        post :create, :flow => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested flow" do
        Router::Rule::Flow.stub(:find).with("37") { mock_flow }
        mock_flow.should_receive(:update_attributes).with({'net_type' => 'ext'})
        put :update, :id => "37", :router_flow => {'net_type' => 'ext'}
      end

      it "assigns the requested flow as @flow" do
        Router::Rule::Flow.stub(:find) { mock_flow(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:router_flow).should be(mock_flow)
      end

      it "redirects to the flow" do
        Router::Rule::Flow.stub(:find) { mock_flow(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(router_flows_url)
      end
    end

    describe "with invalid params" do
      it "assigns the flow as @flow" do
        Router::Rule::Flow.stub(:find) { mock_flow(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:router_flow).should be(mock_flow)
      end

      it "re-renders the 'edit' template" do
        Router::Rule::Flow.stub(:find) { mock_flow(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested flow" do
      Router::Rule::Flow.stub(:find).with("37") { mock_flow }
      mock_flow.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the router_flows list" do
      Router::Rule::Flow.stub(:find) { mock_flow }
      delete :destroy, :id => "1"
      response.should redirect_to(router_flows_url)
    end
  end

end
