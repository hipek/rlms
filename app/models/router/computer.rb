class Router::Computer < ActiveRecord::Base
  validates_presence_of :mac_address, :name, :ip_address
  validates_uniqueness_of :mac_address, :ip_address
  validates_format_of :mac_address, :with => /[0-9a-fA-F][0-9a-fA-F][:-][0-9a-fA-F][0-9a-fA-F][:-][0-9a-fA-F][0-9a-fA-F][:-][0-9a-fA-F][0-9a-fA-F][:-][0-9a-fA-F][0-9a-fA-F][:-][0-9a-fA-F][0-9a-fA-F]/

  before_validation :upcase_mac

  SORT_BY_IP = "substr( `ip_address` , '.', -1 ) + 0"

  scope :without_router, where("name != 'router'")
  scope :sorted_by_ip, order(SORT_BY_IP)

  class <<self
    def all_for_dhcpd
      without_router.sorted_by_ip.all
    end

    def allow_computers
      without_router.sorted_by_ip.all
    end

    def blocked_computers
      []
    end

    def find_router
      find_by_name('router')
    end

    def next_ip
      ip = all_for_dhcpd.last.try:ip_address
      return ip if ip.blank?
      elements = ip.split('.')
      elements[elements.length - 1] = (elements.last.to_i + 1).to_s
      elements.join('.')
    end

    def all_online
      lines = ShellCommand.arp.delete('(/)/[/]').gsub('?','unknown').strip.split(/\n/)
      computers = []
      lines.each do |line|
        parts = line.split(' ')
        computers << new(:name => parts.first, :ip_address => parts[1], :mac_address => parts[3])
      end
      computers
    end
  end

  def block firewall
    FwRule.block_computer self, firewall
  end

  def pass firewall
    FwRule.pass_computer self, firewall
  end

  def valid_name
    name.latinize.downcase.gsub(' ', '_').gsub('/','_').gsub('\\','_')
  end

  def router?
    name.match(/ROUTER/)
  end

  def upcase_mac
    return unless mac_address.present?
    self.mac_address = self.mac_address.gsub(/-|;|,|\./, ':')
    self.mac_address = self.mac_address.to_s.upcase
  end
end
