class Router::Interface < Router::BaseSetting
  define_fields(
    :config => 'manually',
    :name => '',
    :ip_address => '',
    :ip_mask => '',
    :ip_gateway => '',
    :net_type => ''
  )
end
