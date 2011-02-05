class Router::Main < Router::BaseSetting
  define_fields(
    :dns_server1 => '',
    :dns_server2 => '',
    :name => 'localhost.localdomain',
    :int_imq => 'imq0'
  )

  validates_presence_of :name, :dns_server1

  has_many :tc_classids, :class_name => 'Router::Tc::Classid', :foreign_key => 'router_id'
  has_many :flow_rules, :through => :tc_classids, :source => :flow_rules
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
      :subnet_mask => int_inf.ip_mask,
      :subnet => int_inf.subnet,
      :broadcast_address => int_inf.broadcast,
      :range_from => int_inf.incomplete_ip,
      :range_to => int_inf.incomplete_ip
    }
  end

  def iptables_attrs
    { :allow_computers => Router::Computer.allow_computers,
      :blocked_computers => Router::Computer.blocked_computers,
      :iptables => Router::Service::Base.iptables,
      :extif => ext_inf.name,
      :extip => ext_inf.ip_auto,
      :intif => int_inf.name,
      :intip => int_inf.ip_auto,
      :intnet => "#{int_inf.subnet}/#{int_inf.subnet_short_mask}"
    }
  end

  def install_iptables_conf
    ip_conf = ConfTemplate.new("iptables.sh", iptables_attrs)
    ip_conf.write
    ip_conf
  end

  protected

  def interfaces_attributes= attrs
    self.interfaces = attrs.map{ |key, att|
      Router::Interface.new(att || key)
    }
  end
end
