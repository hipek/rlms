module GetText
  class <<self
    def included klass
      klass.class_eval do
        extend ClassMethods
        helper_method :_ if klass.to_s == 'ApplicationController'
      end
    end
  end

  def _(text)
    self.class._(text)
  end
  
  module ClassMethods
    def _(text)
      text
    end
  end
end
