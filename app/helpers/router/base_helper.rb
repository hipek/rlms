module Router::BaseHelper
  include MenusSupport::HelperMethods

  def menus_folder
    'router/shared/menus'
  end

  def all_protocols
    %w"TCP UDP ALL".map{|pro| [pro, pro.downcase]}
  end
  
  def ip_configs
    %w"auto manually".map{|c| [_(c.camelcase), c]}
  end
  
  def interfaces
    @interfaces ||= begin
      infs = ShellCommand.read_interfaces
      infs = %w"eth0 eth1" if infs.blank?
      infs
    end
  end
end
