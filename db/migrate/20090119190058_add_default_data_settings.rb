class AddDefaultDataSettings < ActiveRecord::Migration
  def self.up
    %w(dhcp iptables iptables-save iptables-save iptables-restore ifconfig arp).each do |n|
      Service.find_or_create_by_name(:name => n)
    end
  end

  def self.down
    Service.delete_all
  end
end
