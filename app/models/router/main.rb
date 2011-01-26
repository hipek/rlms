class Router::Main < Router::BaseSetting
  define_fields(
    :int_inf => 'eth0',
    :ext_inf => 'eth1',
    :int_ip => '',
    :int_mask => '',
    :int_gateway => '',
    :ext_ip => 'auto',
    :ext_mask => '',
    :ext_gateway => ''
  )
  class <<self
    def instance
      first || new
    end
  end
end
