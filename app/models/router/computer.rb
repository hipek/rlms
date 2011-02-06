class Router::Computer < ActiveRecord::Base
  validates_presence_of :mac_address, :name, :ip_address
  validates_uniqueness_of :mac_address, :ip_address
  validates_format_of :mac_address, :with => /[0-9a-fA-F][0-9a-fA-F][:-][0-9a-fA-F][0-9a-fA-F][:-][0-9a-fA-F][0-9a-fA-F][:-][0-9a-fA-F][0-9a-fA-F][:-][0-9a-fA-F][0-9a-fA-F][:-][0-9a-fA-F][0-9a-fA-F]/

  before_validation :upcase_mac

  SORT_BY_IP = "substr( `ip_address` , 8) + 0"

  scope :without_router, where("lower(name) != lower('router')")
  scope :sorted_by_ip, order(SORT_BY_IP)
  scope :active, where(:active => 1)
  scope :not_active, where(:active => 0)

  has_many :forward_ports, :class_name => 'Router::Rule::ForwardPort', :foreign_key => 'computer_id'

  class <<self
    def all_for_dhcpd
      without_router.sorted_by_ip.all
    end

    def allow_computers
      active.all_for_dhcpd
    end

    def blocked_computers
      not_active.all_for_dhcpd
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
    
    def all_as_pairs
      allow_computers.map{|c| [c.name_with_ip, c.id]}
    end
  end

  def name_with_ip
    "#{name} (#{ip_address})"
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
    name.match(/ROUTER/i)
  end

  def upcase_mac
    return unless mac_address.present?
    self.mac_address = self.mac_address.gsub(/-|;|,|\./, ':')
    self.mac_address = self.mac_address.to_s.upcase
  end
end
