require 'digest'
require 'uri'
module Junziqian
  module Tool
    class HttpSignUtils
      class << self
        def create_http_url body_params, timestamp = nil
          timestamp ||= get_millisecond
          sign=create_http_sign(body_params, timestamp)
          url='timestamp='+timestamp+'&'; #timestamp必须放在最前面民
          body_params.each do |k, v|
            url += k.to_s + URI::escape(v.strip)
          end
          url += "sign=#{sign}"
        end

        def get_millisecond
          (Time.now.to_f*1000).to_i.to_s
        end

        def create_http_sign body_params, timestamp = nil
          timestamp ||= get_millisecond
          contactStr = []
          contactStr << get_params(body_params)
          contactStr << ("timestamp"+timestamp)
          contactStr << ("appKey"+ Cfg::ClientInfo.app_key)
          contactStr << ("appSecret"+ Cfg::ClientInfo.app_secret;)
          Digest::SHA1.hexdigest(contactStr.join(''));
        end

        def get_params(hash)
          contactStr=[]
          if hash.present?
            hash.sort.map {|array_item|
              contactStr << [array_item[0], array_item[1].strip]
            }
          end
          contactStr.flatten.join('')
        end
      end
    end
  end
end
