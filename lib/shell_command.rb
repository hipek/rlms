class ShellCommand
  class <<self
    def settings
      @settings ||= YAML.load_file(Rails.root.join('config/settings.yml'))
    end
    
    def set_password passwd
      @password = passwd
    end

    def restart_dhcpd
      change_service Router::Service::Base.by_name('dhcp')
    end

    def change_service srv, options="restart"
      run_command srv.init_path, options, true
    end

    def install_config srv, src_path
      run_command "cat", "#{src_path} > #{srv.config_path}", true
    end

    def install_dhcpd_config dhcpd_template
      install_config Router::Service::Base.by_name('dhcp'), dhcpd_template.dest_path
    end

    def ifconfig options=''
      ifconfig = Router::Service::Base.by_name('ifconfig')
      run_command ifconfig.bin_path, options
    end

    def arp options="-a"
      arp = Router::Service::Base.by_name('arp')
      run_command arp.bin_path, options
    end

    def ip_tables options='-L -t nat'
      ip_tables = Router::Service::Base.by_name('iptables')
      run_command ip_tables.bin_path, options
    end
  
    def ip_tables_save ip_table="nat"
      iptables = Router::Service::Base.by_name('iptables-save')
      options = "-t #{ip_table}" unless ip_table.blank?
      run_command iptables.bin_path, (options || '')
    end
  
    def ip inf
      result = ifconfig "#{inf} | awk /#{inf}/'{ next}//{split($0,a,\":\");split(a[2],a,\" \");print a[1];exit}'"
      result.strip
    end

    def ip_tables_list ip_table=nil
      ip_table = 'filter' if ip_table.blank?
      ip_tables "-L -t #{ip_table} --line-numbers"
    end

    def find_file name, dir="/usr"
      run_command "find", "#{dir} -name \"#{name}\""
    end
  
    def read_interfaces
      ifconfig("| cut -b1-8 | grep -e [a-z]").gsub(' ','').split(/\n/)
    end
  
    def run_command command, options='', use_sudo = false
      return '' if command.blank?
      @password ||= sudo_passwd if use_sudo
      # p "#{command} #{options}"
      use_sudo ? `echo "#{@password}" | sudo -S sh -c "#{command} #{options}" 2>&1` : `#{command} #{options} 2>&1`
    end

    def sudo_passwd
      settings['passwd']
    end
  end
end
