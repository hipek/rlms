class FwRuleContainer
  class <<self
    def in_open_ports
      rules[:filter][:input].select{|r| r.mod_option == '--state NEW,RELATED,ESTABLISHED' && r.mod == 'state'}
    end

    def forward_ports
      rules[:filter][:forward].select{|r| r.dest_port != nil && r.target == 'ACCEPT' && r.dest_ip != nil}
    end
    
    def dnat_ports
      rules[:nat][:prerouting].select{|r| r.target == 'DNAT' && r.aft_option == '--to-destination' && r.dest_ip != nil}
    end
    
    def single_forward_ports
      forward_ports.select{|r| !r.dest_port.match(/:/) }
    end
    
    def range_forward_ports
      forward_ports.select{|r| r.dest_port.match(/:/) }
    end
    
    def single_dnat_ports
      dnat_ports.select{|r| !r.dest_port.match(/:/) }
    end
    
    def range_dnat_ports
      dnat_ports.select{|r| r.dest_port.match(/:/) }
    end
    
    def ip_tables
      rules.keys
    end
    def chains_for ipt
      result = rules[get_key(ipt)]
      result.blank? ? [] : result.keys
    end
    def rules_for ipt, chain=nil
      ipt = 'filter' unless ip_tables.include?(get_key(ipt))
      ipt_rules = rules_for_ip_table(ipt)
      return ipt_rules unless ipt_rules.keys.include?(get_key(chain))
      ipt_rules[get_key(chain)] || []
    end
    def rules_for_ip_table ipt
      rules[get_key(ipt)] || {}
    end
    def all_rules
      @@all_rules
    end
    alias_method :rules, :all_rules
    def read_all_rules
      FwRuleParser.new.read_iptables(ShellCommand.ip_tables_save(nil))
    end
    alias_method :read, :read_all_rules
    
    private
    
    def get_key arg
      arg.to_s.downcase.to_sym unless arg.blank?
    end
  end
  
  private
  @@all_rules = {}
end
