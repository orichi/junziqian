module Junziqian
  module Interface
    class FileLinkRequest < BaseRequest
      attr_accessor :applyNo

      def initialize apply_no
        self.applyNo = apply_no
      end
      def version
        '1.0'
      end

      def method
        'sign.link.file'
      end

      def ingore_signs
        []
      end

      def query_params
        {applyNo: applyNo}
      end

      def file_path
        Dir.mkdir(ENV['contract_path']) if  ENV['contract_path'] && Dir.exist?(ENV['contract_path'])
        ENV['contract_path'] || '/tmp'
      end



      def request
        result = Tool::RequestTool.do_post_by_requestObj(self)
        if result['success'] == true
          link = result['link']
          system(`curl '#{link}' -o #{file_path}/applyNo#{self.applyNo}.pdf`)
        else
          'error'
        end
      end
    end
  end
end
