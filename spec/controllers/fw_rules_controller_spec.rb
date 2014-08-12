require 'spec_helper'

describe FwRulesController do
  fixtures :users
  render_views

  before(:each) do
    login_as(:quentin)
    stub_shell_commands
  end

  describe "handling GET /fw_rules" do

    before(:each) do
      @fw_rule = build_model(FwRule)
      allow(FwRuleContainer).to receive(:rules_for).and_return('input' => [@fw_rule])
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
  
    it "should find all fw_rules" do
      do_get
    end
  
    it "should assign the found fw_rules for the view" do
      do_get
      assigns[:fw_rules].should == {'input' => [@fw_rule]}
    end
  end

  describe "handling GET /fw_rules/1" do

    before(:each) do
      @fw_rule = build_model(FwRule, :id => 1)
      allow(FwRule).to receive(:find_by_id).and_return(@fw_rule)
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
  
    it "should find the fw_rule requested" do
      do_get
    end
  
    it "should assign the found fw_rule for the view" do
      do_get
      assigns[:fw_rule].should equal(@fw_rule)
    end
  end

  describe "handling GET /fw_rules/new" do

    before(:each) do
      @fw_rule = build_model(FwRule)
      allow(FwRule).to receive(:new).and_return(@fw_rule)
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
  
    it "should create an new fw_rule" do
      FwRule.should_receive(:new).and_return(@fw_rule)
      do_get
    end
  
    it "should not save the new fw_rule" do
      @fw_rule.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new fw_rule for the view" do
      do_get
      assigns[:fw_rule].should equal(@fw_rule)
    end
  end

  describe "handling GET /fw_rules/1/edit" do

    before(:each) do
      @fw_rule = build_model(FwRule)
      allow(FwRule).to receive(:find_by_id).and_return(@fw_rule)
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
  
    it "should find the fw_rule requested" do
      do_get
    end
  
    it "should assign the found FwRule for the view" do
      do_get
      assigns[:fw_rule].should equal(@fw_rule)
    end
  end

  describe "handling POST /fw_rules" do

    before(:each) do
      @fw_rule = build_model(FwRule, :id => "1")
      allow(FwRule).to receive(:new).and_return(@fw_rule)
    end
    
    describe "with successful save" do
  
      def do_post
        @fw_rule.should_receive(:save).and_return(true)
        post :create, :fw_rule => {}
      end
  
      it "should create a new fw_rule" do
        FwRule.should_receive(:new).with({}).and_return(@fw_rule)
        do_post
      end

      it "should redirect to the new fw_rule" do
        do_post
        response.should redirect_to(fw_rule_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @fw_rule.should_receive(:save).and_return(false)
        post :create, :fw_rule => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /fw_rules/1" do

    before(:each) do
      @fw_rule = build_model(FwRule, :id => "1")
      allow(FwRule).to receive(:find_by_id).and_return(@fw_rule)
    end
    
    describe "with successful update" do

      def do_put
        @fw_rule.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the fw_rule requested" do
        do_put
      end

      it "should update the found fw_rule" do
        do_put
        assigns(:fw_rule).should equal(@fw_rule)
      end

      it "should assign the found fw_rule for the view" do
        do_put
        assigns(:fw_rule).should equal(@fw_rule)
      end

      it "should redirect to the fw_rule" do
        do_put
        response.should redirect_to(fw_rule_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @fw_rule.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /fw_rules/1" do

    before(:each) do
      @fw_rule = build_model(FwRule)
      allow(@fw_rule).to receive(:destroy).and_return(true)
      allow(FwRule).to receive(:find_by_id).and_return(@fw_rule)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the fw_rule requested" do
      do_delete
    end
  
    it "should call destroy on the found fw_rule" do
      @fw_rule.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the fw_rules list" do
      do_delete
      response.should redirect_to(fw_rules_url)
    end
  end
end
