class BaseSetting < ActiveRecord::Base
  class << self
    def define_fields *args
      @@fields[self.to_s] = args.flatten.first.keys
      defaults *args
    end
    
    def fields
      @@fields[self.to_s]
    end
    
    def define_instance_methods
      fields.each do |field|
        has_one(:"#{field}_setting", 
                :class_name => 'Setting', 
                :foreign_key => 'base_setting_id' , 
                :conditions => ["field_name = ?", field.to_s], :dependent => :destroy)
        define_method field do
          result = self.send(:"#{field}_setting") || Setting.new
          result.value
        end
        define_method "#{field}=" do |arg|
          self.send(:"#{field}_setting=", Setting.new(:value => arg, :field_name => field.to_s))
        end
      end
    end
  
  end

  def fields_with_values
    options = {}
    self.class.fields.each do |f|
      options.merge!(f.to_sym => self.send(f))
    end
    options
  end

  private
  @@fields = {}
end
