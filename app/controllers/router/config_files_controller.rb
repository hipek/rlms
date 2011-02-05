class Router::ConfigFilesController < Router::BaseController
  def dhcp
    @conf_template = Router::Dhcp.instance.install_conf
    render :action => 'conf'
  end

  def iptables
    @conf_template = Router::Main.instance.install_iptables_conf
    render :action => 'conf'
  end
end
