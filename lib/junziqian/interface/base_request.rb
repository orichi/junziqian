module Junziqian
  module Interface
    class BaseRequest
      def content_type
        'application/x-www-form-urlencoded; charset=UTF-8'
      end

      def query_params
        {}
      end

      def ignores_params
        []
      end
    end
  end
end
