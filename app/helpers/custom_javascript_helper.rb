module CustomJavascriptHelper
  def observe_input_field selector, options = {}
    options[:event] ||= 'change'
    options[:method] ||= 'post'
    options[:with] = "+ #{options[:with]}" if options[:with].present?
    script = %{
      $(function() {
        $("input[#{selector}]").#{options[:event]}( function() {
          $.#{options[:method]}(this.getAttribute("data-url")#{options[:with]});
        })
      })
    }
    javascript_tag script
  end
end
