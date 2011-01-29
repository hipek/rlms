module MenusSupport

  def self.included klass
    klass.send :extend, ClassMethods
  end

  module HelperMethods
    def mainmenu
      render :partial => "#{menus_folder}/#{@menu_name}_menu" unless @menu_name.blank?
    end

    def submenu
      render :partial => "#{menus_folder}/#{@submenu_name}_submenu" unless @submenu_name.blank?
    end
    
    def menus_folder
      'menus'
    end
  end

  module ClassMethods

    def mainmenu name, options={}
      define_menu name, 'menu', options
    end

    def submenu name, options={}
      define_menu name, 'submenu', options
    end

  protected

    def define_menu name, instanse_name, options = {}
      before_filter options do |controller|
        controller.instance_variable_set "@#{instanse_name}_name", name
      end
    end

  end

end
