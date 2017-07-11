module Junziqian
  module Interface
    class Ping < BaseRequest
      def version
        '1.0'
      end

      def method
        'ping'
      end

      def ingore_signs
        []
      end



      def request
        Tool::RequestTool.do_post_by_requestObj(self)
      end
    end
  end
end