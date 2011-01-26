class AddTypeToService < ActiveRecord::Migration
  def self.up
    add_column :services, :type, :string, :limit => 32
    %w(iptables iptables-save iptables-save iptables-restore ifconfig arp).each do |n|
      s = Service.find_or_create_by_name(:name => n)
      s.send :write_attribute, :type, 'Router::Service::Simple'
      s.save
    end
  end

  def self.down
    remove_column :services, :type
  end
end