module ArDefaults
  extend ActiveSupport::Concern

  included do
    after_initialize :assign_default_values
  end

  def assign_default_values
    self.class._defaults.each do |name, value|
      public_send(:"#{name}=", value) unless public_send(name).present?
    end
  end

  module ClassMethods
    def _defaults
      @_defaults ||= {}
    end

    def defaults(attrs = {})
      @_defaults = attrs
    end
  end
end

ActiveRecord::Base.send :include, ArDefaults
