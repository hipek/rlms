class FwRuleParser
  attr_accessor :ip_table_rule

  def initialize arg=''
    self.ip_table_rule = arg
  end

  def parse
    ip_table_rule =~/(-A\s\S+\s)?(-s\s\d+\.\d+\.\d+\.\d+\/?\d*\.*\d*\.*\d*\.*\d*\s)?(-d\s\d+\.\d+\.\d+\.\d+\/?\d*\.*\d*\.*\d*\.*\d*\s)?(-i\s\w+\d?\s)?(-o\s\w+\d?\s)?(-p\s!?\s?\w+\s)?(-m\s\w+\s)?(--\w+\s\S+\s)?(-m\s\w+\s)?(--sport\s\d+:?\d+\s)?(--dport\s\d+:?\d+\s)?(--tcp-flags\s\S+\sSYN\s)?(-m\sconnlimit\s--connlimit-above\s\d+\s--connlimit-mask\s\d+\s)?(-j\s\S+)(\s\S+)?(\s\S+)?/

    fw_rule = FwRule.new :cmd => extract_option($1),
      :chain_name => extract_value($1),
      :src_ip => extract_value($2),
      :dest_ip => extract_value($3),
      :in_int => extract_value($4),
      :out_int => extract_value($5),
      :protocol => extract_all_values($6),
      :mod => extract_value($7),
      :mod_option => ($8).andand.strip,
      :mod_protocol => extract_value($9),
      :src_port => extract_value($10),
      :dest_port => extract_value($11),
      :tcp_flags => extract_all_values($12),
      :tcp_flags_option => ($13).andand.strip,
      :target => extract_value($14),
      :aft_option => extract_value($15),
      :aft_argument => extract_value($16)
    if extract_value($7) && FwRule::PROTOCOLS.include?(extract_value($7).upcase)
      fw_rule.mod_protocol = extract_value($7)
      fw_rule.mod = nil
    end
    if extract_option($8) == 'sport'
      fw_rule.src_port = extract_value($8)
      fw_rule.mod_option = nil
    end
    if extract_option($8) == 'dport'
      fw_rule.dest_port = extract_value($8)
      fw_rule.mod_option = nil
    end
    ip_table_rule =~ /(-t\s\S+\s)?/
    unless extract_value($1).blank?
      fw_rule.ip_table = extract_value($1)
    end
    fw_rule
  end

  def extract_option o
    o.andand.split(' ').andand.first.andand.delete('-')
  end

  def extract_value v
    v.andand.split(' ').andand.last
  end

  def extract_all_values ov
    if a = ov.andand.split(' ')
      a.delete_at(0)
      a.join(' ')
    end
  end

  def read_firewall data, save_it=false
    rules = []
    data.split(/\n/).each do |line|
      if line[0,1] == "*"
        @ip_table_name = line.gsub('*','')
        FwRuleContainer.all_rules[@ip_table_name.to_sym]={}
      end
      if line[0,1] == ":"
        chain_name = line.gsub(':','').split(' ').first
        FwRuleContainer.all_rules[@ip_table_name.to_sym][:"#{chain_name.downcase}"] ||= []
      end
      if line[0,2] == "-A"
        self.ip_table_rule = line
        rule = self.parse
        rule.ip_table = @ip_table_name
        chain_idx = rule.chain_name.downcase.to_sym
        FwRuleContainer.all_rules[@ip_table_name.to_sym][chain_idx] ||= []
        FwRuleContainer.all_rules[@ip_table_name.to_sym][chain_idx] << rule
        rules << rule
        rule.save if save_it
      end
    end
    rules
  end
  alias_method :read_iptables, :read_firewall
    
  def read_firewall_file file_name
    read_firewall(File.read(file_name), true)
  end
end
