module ButtonsHelper
  def submit_tag(name, opts = {})
    opts[:class] ||= 'btn btn-primary btn-xs'
    super(name, opts)
  end

  def small_btn_tag(name, opts = {})
    submit_tag(name, class: 'btn btn-primary btn-xs')
  end
end
