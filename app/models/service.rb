class Service < ActiveRecord::Base
  def self.by_name service_name
    find_by_name(service_name) || new(:bin_path => service_name)
  end
end
