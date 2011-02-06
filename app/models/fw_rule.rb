class FwRule < ActiveRecord::Base
  scope :ip_table, lambda {|filter|
    filter = '%' if filter.nil? || (!filter.nil? && filter == '')
    {:conditions => ['lower(ip_table) like lower(?)', filter ]}
  }
  scope :chain, lambda {|filter|
    filter = '%' if filter.nil? || (!filter.nil? && filter == '')
    {:conditions => ['lower(chain_name) like lower(?)', filter ]}
  }

  TARGETS = ['ACCEPT', 'DROP','MARK', 'SNAT', 'DNAT'].freeze
  PROTOCOLS = ['ALL','TCP', 'UDP', 'ICMP'].freeze
  IN_INT = ['INPUT', 'FORWARD', 'PREROUTING']
  OUT_INT = ['OUTPUT', 'FORWARD', 'POSTROUTING']
  CMDS = ['A', 'I', 'P']

  def self.chain_names ip_table='filter'
    FwRuleContainer.chains_for(ip_table).map{|cn| [cn.to_s] }
  end

  def self.ip_tables
    FwRuleContainer.ip_tables.map{ |cn| [cn.to_s, cn.to_s.downcase] }
  end
  
  def self.blocked_ips
    FwRuleContainer.rules_for(:nat,'PREROUTING').map{ |chn| chn.src_ip.split('/').first unless chn.src_ip.blank? }
  end
  
  def self.blocking_rule computer, firewall
    return FwRule.new if firewall.blank? || computer.blank?
    FwRuleParser.new("-t nat -A PREROUTING -s #{computer.ip_address} -p tcp -m tcp --dport 1:65535 -j DNAT --to-destination #{firewall.blocking_ip_port}").parse
  end
  
  def self.passing_rule computer, firewall
    return FwRule.new if firewall.blank? || computer.blank?
    FwRuleParser.new("-t nat -A POSTROUTING -s #{computer.ip_address} -o #{firewall.ext_inf} -j SNAT --to-source #{firewall.auto_ext_ip}").parse
  end
  
  def self.block_computer computer, firewall
    ShellCommand.ip_tables blocking_rule(computer, firewall).to_ipt("D")
    ShellCommand.ip_tables blocking_rule(computer, firewall).to_ipt("A")
    ShellCommand.ip_tables passing_rule(computer, firewall).to_ipt("D")
  end
  
  def self.pass_computer computer, firewall
    ShellCommand.ip_tables blocking_rule(computer, firewall).to_ipt("D")
    ShellCommand.ip_tables passing_rule(computer, firewall).to_ipt("D")
    ShellCommand.ip_tables passing_rule(computer, firewall).to_ipt("A")
  end
  
  def to_ipt ipcmd=nil, rulenum=nil
    new_rule = self.clone
    new_rule.cmd = ipcmd if ipcmd
    new_rule.order = rulenum if rulenum
    result = ""
    [:ip_table, :cmd, :chain_name, :order, :src_ip, :dest_ip, :in_int, :out_int, 
     :protocol, :mod, :mod_option, :mod_protocol, :src_port, :dest_port, 
     :tcp_flags, :tcp_flags_option, :target, :aft_option, :aft_argument].each do |f|
      result += new_rule.value_of(f)
    end
    result.strip
  end
    
  def value_of field
    return "#{field_options[field.to_sym]}#{value_of_field(field)} " unless value_of_field(field).blank?
    ''
  end
  
  private
  
  def value_of_field field
    eval field.to_s if field
  end
  
  def field_options
    {
      :ip_table => "-t ",
      :cmd => "-",
      :src_ip => "-s ",
      :dest_ip => "-d ",
      :in_int => "-i ",
      :out_int => "-o ",
      :protocol => "-p ",
      :mod => "-m ",
      :mod_protocol => "-m ",
      :src_port => "--sport ",
      :dest_port => "--dport ",
      :tcp_flags => "--tcp-flags ",
      :target => "-j "
    }
  end
end
