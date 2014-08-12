require 'spec_helper'

describe WebJob do
  before(:each) do
    @web_job = WebJob.new :name => 'a', :category => 'b', :source => 'c'
  end

  it "should be valid" do
    @web_job.should be_valid
  end

  it "should have pending state" do
    @web_job.save!
    @web_job.state.should == 'pending'
  end

  it "should transit from pending to queuing" do
    @web_job.save!
    @web_job.start!
    @web_job.state.should == 'queuing'
  end

  it "should transit from pending to queuing" do
    @web_job.should_receive(:run).and_return(true)
    @web_job.save!
    @web_job.start!
    @web_job.start!
    @web_job.state.should == 'running'
  end

  it "should transit from pending to queuing" do
    @web_job.save!
    @web_job.start!
    @web_job.start!
    @web_job.finish!
    @web_job.state.should == 'done'
  end

  it "should fill data from url" do
    url = "http://www.widewallpapers.net/mod/babes/1920/wide-wallpaper-1920x1200-120.jpg
http://wallpapers.photo4everyone.com/celebrity/H/Holly-Weber/Holly-Weber-62.jpg
http://ddfcash.com/PROMO/content/ddfbusty/pics/6687/fulm/067.jpg"
    @web_job.source = url
    @web_job.generate
    @web_job.body.should include("wide-wallpaper-1920x1200-120.jpg")
    @web_job.body.should include("wide-wallpaper-1920x1200-001.jpg")
    @web_job.body.should_not include("wide-wallpaper-1920x1200-000.jpg")
  end
end
