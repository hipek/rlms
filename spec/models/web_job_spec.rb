require 'rails_helper'

describe WebJob do
  let(:web_job) do
    WebJob.new :name => 'a', :category => 'b', :source => 'c', state: 'pending'
  end

  it "should be valid" do
    expect(web_job).to be_valid
  end

  it "should have pending state" do
    web_job.save!
    expect(web_job.state).to eql 'pending'
  end

  it "should transit from pending to queuing" do
    web_job.save!
    web_job.start!
    expect(web_job.state).to eql 'queuing'
  end

  it "should transit from pending to queuing" do
    expect(web_job).to receive(:run).and_return(true)
    web_job.save!
    web_job.start!
    web_job.start!
    expect(web_job.state).to eql 'running'
  end

  it "should transit from pending to queuing" do
    web_job.save!
    web_job.start!
    web_job.start!
    web_job.finish!
    expect(web_job.state).to eql 'done'
  end

  it "should fill data from url" do
    url = "http://www.widewallpapers.net/mod/babes/1920/wide-wallpaper-1920x1200-120.jpg
http://wallpapers.photo4everyone.com/celebrity/H/Holly-Weber/Holly-Weber-62.jpg
http://ddfcash.com/PROMO/content/ddfbusty/pics/6687/fulm/067.jpg"
    web_job.source = url
    web_job.generate
    expect(web_job.body).to include("wide-wallpaper-1920x1200-120.jpg")
    expect(web_job.body).to include("wide-wallpaper-1920x1200-001.jpg")
    expect(web_job.body).to_not include("wide-wallpaper-1920x1200-000.jpg")
  end
end
