require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/user_groups/index" do
  before(:each) do
    assigns[:groups] = []
    assigns[:users] = array_to_will_paginate([])

  end
  it "should render index" do
    render 'user_groups/index'
  end
end
