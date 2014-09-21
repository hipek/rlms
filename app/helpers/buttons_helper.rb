module ButtonsHelper
  def submit_tag(name, opts = {})
    opts[:class] ||= 'btn btn-primary'
    super(name, opts)
  end
end
