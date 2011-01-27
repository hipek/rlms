class Router::Main < Router::BaseSetting
  define_fields(
    :int_config => 'manually',
    :ext_config => 'auto',
    :int_inf => 'eth0',
    :ext_inf => 'eth1',
    :int_ip => '',
    :int_mask => '',
    :int_gateway => '',
    :ext_ip => '',
    :ext_mask => '',
    :ext_gateway => '',
    :dns_server1 => '',
    :dns_server2 => ''
  )
  class <<self
    def instance
      first || new
    end
  end
end
