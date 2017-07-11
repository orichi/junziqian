require 'base64'
module Junziqian
  module Tool
    class AttacheUtils
      def initialize file_path
        @file_path = file_path
      end

      def file_type
        match_data = @file_path.match(/\.([a-z]+)$/)
        match_data ? match_data[1] : ''
      end

      def value
        @file_path
      end

      def file_name
        @file_path.match(/([^\/]+\.([a-z]+))$/)[0]
      end

      def uploadStr
        file =File.open(@file_path)
        b = file.readlines().join('')
        c = Base64.strict_encode64(file_name) +'@'+ Base64.strict_encode64(b)

        # array('+','/','='),array('-','_','')
        c.gsub('+', '-').gsub('/','_').gsub('=','')
      end
    end
  end

end