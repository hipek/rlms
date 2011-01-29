class Router::Main < Router::BaseSetting
  define_fields(
    :dns_server1 => '',
    :dns_server2 => '',
    :name => 'localhost.localdomain'
  )

  has_many :interfaces, :class_name => 'Router::Interface', :foreign_key => 'parent_id' do
    def find_by_net_type t
      select{|a| a.net_type == t}.first
    end
  end

  class <<self
    def instance
      first || new
    end
  end

  def ext_inf
    interfaces.find_by_net_type('ext')
  end

  def int_inf
    interfaces.find_by_net_type('int')
  end

  def dhcp_attrs
    { :router => self,
      :gateway => int_inf.ip_address,
      :domain_name_server1 => dns_server1,
      :domain_name_server2 => dns_server2,
      :subnet_mask => int_inf.ip_mask
    }
  end

  protected

  def interfaces_attributes= attrs
    self.interfaces = attrs.map{ |key, att|
      Router::Interface.new(att || key)
    }
  end
end
