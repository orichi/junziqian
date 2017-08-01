require 'digest'
require 'net/http'
require 'uri'
require 'json'
require 'mime/types'

module Junziqian
  module Tool
    class RequestTool
      CV = '1.1.1'
      BOUNDARY = '00content0boundary00'
      class << self
        def sign(query_params, ignore_params, header_map, ext_info, content_type = 'application/x-www-form-urlencoded; charset=UTF-8')
          #raise '头参数不能为空' if secret.blank? || header_map.blank?

          contactStr = [Cfg::ClientInfo.app_secret]
          contactStr << contactValues(query_params, ignore_params, content_type)
          contactStr << contactValues(header_map)
          contactStr << contactValues(ext_info)

          # print contactStr.join('')
          Digest::SHA1.hexdigest(contactStr.join('')).upcase
        end

        def contactValues(query_params, ignores = [], content_type = 'application/x-www-form-urlencoded; charset=UTF-8')
          contactStr = []
          is_multipart = content_type.downcase.match('multipart/form-data') ? true : false
          unless query_params.empty?
            req_array = query_params.select {|k, v| !ignores.include?(k)}
            req_array.sort.each do |array_item|
              contactStr << array_item[0]
              if array_item[1]
                contactStr << (array_item[1].is_a?(Junziqian::Tool::AttacheUtils) ? array_item[1].value : array_item[1].to_s.strip)
              end
            end
          end
          contactStr.join('')
        end

        def get_heads(method = 'POST', version = '1.0')
          {"ts" => HttpSignUtils.get_millisecond,
           "locale" => "zh_CN",
           "v" => version,
           "method" => method,
           "appKey" => Cfg::ClientInfo.app_key}
        end

        def get_ext_info
          {'cv' => CV}
        end

        def encrypt_ext_info ext_hash
          contactStr = []
          if ext_hash
            ext_hash.each do |k, v|
              contactStr << "#{k}\001#{v}\002"
            end
          end
          string = contactStr.join('')
          string == '' ? '' : (string[0, string.length-1].to_s)
        end

        def create_head_hash(head_map, ext_info, sign, content_type="application/x-www-form-urlencoded; charset=UTF-8")
          hash = {}
          hash['ext'] = encrypt_ext_info(ext_info)
          hash['sign'] = sign
          hash['user-agent'] = 'php'
          hash['Content-type'] = content_type
          hash['accept'] = 'text/html, image/gif, image/jpeg, *; q=.2, */*; q=.2'
          hash['connection'] = 'keep-alive'
          hash.merge(head_map)
        end

        def do_post(query_params, ignores_params, head_map, content_type = 'application/x-www-form-urlencoded; charset=UTF-8')
          sign_value = sign(query_params, ignores_params, head_map, get_ext_info,content_type);
          uri = URI.parse(Cfg::ClientInfo.services_url)
          head_hash = create_head_hash(head_map, get_ext_info, sign_value, content_type)
          content = if content_type.match('multipart/form-data')
                      head_hash = head_hash.merge({"Content-Type"=> "multipart/form-data, boundary=#{BOUNDARY}"})
                      build_form_data(query_params)
                    else
                      URI.encode_www_form query_params
                    end
          head_hash['Content-Length'] = content.length.to_s
          http = Net::HTTP.new(uri.host, uri.port)
          response = http.post(uri.path, content, head_hash)
          return JSON.parse(response.body)
        end

        def do_post_by_requestObj( requestObj)
          # hash = hash.serialize_keys
          headerMap = get_heads(requestObj.method, requestObj.version)
          query_params = requestObj.query_params
          do_post(query_params, requestObj.ignores_params, headerMap, requestObj.content_type)
        end


        def build_form_data(query_params, boundary = BOUNDARY)
          body = []
          query_params.each do |k, v|
            if v.present?
              body << "--"+ boundary + "\r\n"
              body << "Content-Disposition: form-data; name=\"#{k}\"\r\n\r\n";
              if v.is_a?(Junziqian::Tool::AttacheUtils)
                body << v.uploadStr+"\r\n";
              else
                body << "#{v}\r\n";
              end
            end
          end
          if body.size > 0
            body << "--"+ boundary + "--\r\n";
          end
          body.join('')
        end

        def create_http_sign body_hash, timestamp
          array = [contactValues(body_hash)]
          array << "timestamp#{timestamp}"
          array << "appKey#{Junziqian::Cfg::ClientInfo.app_key}"
          array << "appSecret#{Junziqian::Cfg::ClientInfo.app_secret}"
          Digest::SHA1.hexdigest(array.join(''))
        end
      end
    end
  end
end
