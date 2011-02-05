class Router::Service::Base < ActiveRecord::Base
  set_table_name 'services'

  KINDS = {
    :config => '/etc',
    :init => '/etc/init.d',
    :bin => ['/sbin', '/bin', '/usr/sbin', '/usr/bin', '/usr/local/bin', '/usr/local/sbin']
  }

  class <<self
    def iptables
      find_by_name 'iptables'
    end
  end
end
