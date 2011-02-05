class Router::Interface < Router::BaseSetting
  define_fields(
    :config => 'manually',
    :name => '',
    :ip_address => '',
    :ip_mask => '',
    :ip_gateway => '',
    :net_type => ''
  )

  def subnet
    build_ip_address '0'
  end
  
  def broadcast
    build_ip_address '255'
  end

  def incomplete_ip
    a = ip_address.split('.')
    a.pop
    a.push('').join('.')
  end

  def subnet_short_mask
    ip_mask.split('.').map{|m| m == '255' ? 8 : 0}.sum.to_s
  end

  def ip_auto
    config == 'manually' ? ip_address : ShellCommand.ip(name)
  end

  protected

  def build_ip_address num, mask='255'
    zipped_ip_with_mask.map do |ip, m|
      m == mask ? ip : num
    end.join('.')    
  end

  def zipped_ip_with_mask
    ip_address.split('.').zip(ip_mask.split('.'))
  end
end
