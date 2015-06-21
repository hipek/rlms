# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

YAML.load_file('data/computers.yml').each{|a| Router::Computer.new(   a['attributes'] ).save}
YAML.load_file('data/tcclassid.yml').each{|a| Router::Tc::Classid.new(a['attributes'] ).save}

%w(dhcp iptables iptables-save iptables-save iptables-restore ifconfig arp).each do |n|
  Router::Service::Base.where(:name => n).first_or_create
end

%w(iptables iptables-save iptables-save iptables-restore ifconfig arp).each do |n|
  s = Router::Service::Base.where(:name => n).first_or_create
  s.send :write_attribute, :type, 'Router::Service::Simple'
  s.save
end

Router::Service::ConfInit.where(:name => 'interfaces').first_or_create
Router::Service::ConfInit.where(:name => 'resolv').first_or_create
