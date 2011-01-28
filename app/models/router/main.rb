class Router::Main < Router::BaseSetting
  define_fields(
    :dns_server1 => '',
    :dns_server2 => ''
  )

  has_many :interfaces, :class_name => 'Router::Interface', :foreign_key => 'parent_id'

  class <<self
    def instance
      first || new
    end
  end

  def interfaces_attributes= attrs
    self.interfaces = attrs.map{ |key, att|
      Router::Interface.new(att || key)
    }
  end
end
