class FwSnat < FwRule
  defaults :ip_table => 'NAT', :chain_name => 'POSTROUTING', :target => 'SNAT', :dest_ip => "0.0.0.0", :aft_option => "--to"
end
