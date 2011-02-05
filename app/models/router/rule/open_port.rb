class Router::Rule::OpenPort < ActiveRecord::Base
  module Shared
    def self.included klass
      klass.class_eval do
        validates_presence_of :port, :protocol
      end
    end

    def protocols
      protocol.downcase == 'all' ? %w"tcp udp" : [protocol.downcase]
    end

    def ports
      [port.split(',')].flatten.compact
    end
  end

  include Shared
end
