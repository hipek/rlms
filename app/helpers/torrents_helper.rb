module TorrentsHelper
  def tr_td_row name, value, options = { }
    content_tag :tr, content_tag(:td, name) + content_tag(:td, value), options
  end
  
  def tr_td_row_spacer
    tr_td_row '&nbsp;', '&nbsp;'
  end
end
