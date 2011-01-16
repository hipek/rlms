# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def display_status status
    STATUSES.index(status)
  end

  def display_visibility visibility
    VISIBILITIES.index(visibility)
  end
  
  def indicator_image_tag id='', div='indicator', image = 'ajax_loader.gif'
    content_tag :span, image_tag(image), :id => "#{div}_#{id}", :style => "display: none"
  end

  def indicator_tag id='', div='indicator'
    indicator_image_tag id, div
  end
  
  def indicator_content_tag content, div='indicator'
    indicator_tag content.id, div
  end
  
  def selected_option *sections
    options = sections.flatten
    request.url.include?(options.first) || request.url.include?(options.last) ? {:id => "current"} : { }
  end
end
