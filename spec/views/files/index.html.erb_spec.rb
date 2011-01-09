require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/files/index" do
  before(:each) do
    assigns[:files] = [mock_model(RTorrent::File, 
                                  :path => '/', 
                                  :bytes => 10, 
                                  :bytes_completed => 10, 
                                  :percent_complete => 10, 
                                  :priority => 1)]
    assigns[:torrent_id] = @torrent_id = 'aa'
    template.stub!(:params).and_return(:torrent_id => @torrent_id)
    
    render 'files/index'
  end
  
  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.capture(:col2).should have_tag('table')
  end
end
