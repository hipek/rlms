require 'rails_helper'

describe Dwnl::WebJobsController do
  fixtures :users, :groups, :group_memberships
  render_views

  before(:each) do
    login_as(:admin)
    # add_permission groups(:administrator), "computers"
    stub_shell_commands
  end

  describe "handling GET /dwnl_web_jobs" do

    before(:each) do
      @web_job = build_model(WebJob, :id => 123, :state => 'pending')
      allow(WebJob).to receive(:all).and_return([@web_job])
    end

    def do_get
      get :index
    end

    it "should be successful" do
      do_get
      expect(response).to be_success
    end

    it "should render index template" do
      do_get
      expect(response).to render_template('index')
    end

    it "should find all dwnl_web_jobs" do
      expect(WebJob).to receive(:all).and_return([@web_job])
      do_get
    end

    it "should assign the found dwnl_web_jobs for the view" do
      do_get
      expect(assigns[:web_jobs]).to eql [@web_job]
    end
  end

  describe "handling GET /dwnl_web_jobs/1" do

    before(:each) do
      @web_job = build_model(WebJob, :id => 123)
      allow(WebJob).to receive(:find).and_return(@web_job)
    end

    def do_get
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      expect(response).to be_success
    end

    it "should render show template" do
      do_get
      expect(response).to render_template('show')
    end

    it "should find the web_job requested" do
      expect(WebJob).to receive(:find).with("1").and_return(@web_job)
      do_get
    end

    it "should assign the found web_job for the view" do
      do_get
      expect(assigns[:web_job]).to equal(@web_job)
    end
  end

  describe "handling GET /dwnl_web_jobs/new" do

    before(:each) do
      @web_job = build_model(WebJob)
      allow(WebJob).to receive(:new).and_return(@web_job)
    end

    def do_get
      get :new
    end

    it "should be successful" do
      do_get
      expect(response).to be_success
    end

    it "should render new template" do
      do_get
      expect(response).to render_template('new')
    end

    it "should create an new web_job" do
      expect(WebJob).to receive(:new).and_return(@web_job)
      do_get
    end

    it "should not save the new web_job" do
      expect(@web_job).to_not receive(:save)
      do_get
    end

    it "should assign the new web_job for the view" do
      do_get
      expect(assigns[:web_job]).to equal(@web_job)
    end
  end

  describe "handling GET /dwnl_web_jobs/1/edit" do

    before(:each) do
      @web_job = build_model(WebJob, :id => 122)
      allow(WebJob).to receive(:find).and_return(@web_job)
    end

    def do_get
      get :edit, :id => "1"
    end

    it "should be successful" do
      do_get
      expect(response).to be_success
    end

    it "should render edit template" do
      do_get
      expect(response).to render_template('edit')
    end

    it "should find the web_job requested" do
      expect(WebJob).to receive(:find).and_return(@web_job)
      do_get
    end

    it "should assign the found Dwnl::WebJob for the view" do
      do_get
      expect(assigns[:web_job]).to equal(@web_job)
    end
  end

  describe "handling POST /dwnl_web_jobs" do

    before(:each) do
      @web_job = build_model(WebJob, :id => 1)
      allow(@web_job).to receive(:create_directory)
      allow(WebJob).to receive(:new).and_return(@web_job)
    end

    describe "with successful save" do

      def do_post
        expect(@web_job).to receive(:save).and_return(true)
        post :create, :web_job => {}
      end

      it "should create a new web_job" do
        expect(WebJob).to receive(:new).with({}).and_return(@web_job)
        do_post
      end

      it "should redirect to the new web_job" do
        do_post
        expect(response).to redirect_to(dwnl_web_job_url("1"))
      end

    end

    describe "with failed save" do

      def do_post
        expect(@web_job).to receive(:save).and_return(false)
        post :create, :web_job => {}
      end

      it "should re-render 'new'" do
        do_post
        expect(response).to render_template('new')
      end

    end
  end

  describe "handling PUT /dwnl_web_jobs/1" do

    before(:each) do
      @web_job = build_model(WebJob, :id => 1)
      allow(WebJob).to receive(:find).and_return(@web_job)
    end

    describe "with successful update" do

      def do_put
        expect(@web_job).to receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the web_job requested" do
        expect(WebJob).to receive(:find).with("1").and_return(@web_job)
        do_put
      end

      it "should update the found web_job" do
        do_put
        expect(assigns(:web_job)).to equal(@web_job)
      end

      it "should assign the found web_job for the view" do
        do_put
        expect(assigns(:web_job)).to equal(@web_job)
      end

      it "should redirect to the web_job" do
        do_put
        expect(response).to redirect_to(dwnl_web_job_url("1"))
      end

    end

    describe "with failed update" do

      def do_put
        expect(@web_job).to receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        expect(response).to render_template('edit')
      end

    end
  end

  describe "handling DELETE /dwnl_web_jobs/1" do

    before(:each) do
      @web_job = build_model(WebJob)
      allow(@web_job).to receive(:destroy).and_return(true)
      allow(WebJob).to receive(:find).and_return(@web_job)
    end

    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the web_job requested" do
      expect(WebJob).to receive(:find).with("1").and_return(@web_job)
      do_delete
    end

    it "should call destroy on the found web_job" do
      expect(@web_job).to receive(:destroy)
      do_delete
    end

    it "should redirect to the dwnl_web_jobs list" do
      do_delete
      expect(response).to redirect_to(dwnl_web_jobs_url)
    end
  end
end
