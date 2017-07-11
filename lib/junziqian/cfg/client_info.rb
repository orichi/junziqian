require 'singleton'
module Junziqian
  module Cfg
    class ClientInfo
      include Singleton

      class << self
        def services_url
          ENV['JZQ_SERVICES_URL'] || 'http://sandbox.api.junziqian.com/services'
        end

        def app_key
          ENV['JZQ_APP_KEY'] || 'ecf3961459a07af4'
        end

        def app_secret
          ENV['JZQ_APP_SECRET'] || '187a255fecf3961459a07af4d2035e47'
        end
      end
    end
  end
end
