class FwDnat < FwRule
  defaults :ip_table => 'NAT', :chain_name => 'PREROUTING', :target => 'DNAT', :dest_ip => "0.0.0.0", :aft_option => "--to-destination"
end
