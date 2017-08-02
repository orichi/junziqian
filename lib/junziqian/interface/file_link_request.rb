module Junziqian
  module Interface
    class FileLinkRequest < BaseRequest
      attr_accessor :applyNo
      attr_accessor :storage_path
      attr_accessor :file_name

      def initialize options={}
        self.applyNo = options[:apply_no]
        self.storage_path = options[:storage_path] || '/tmp'
        self.file_name = options[:file_name] || "applyNo#{self.applyNo}.pdf"
        raise 'storage path not exist' unless File.exist?(storage_path)
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
        storage_path
      end



      def request
        result = Tool::RequestTool.do_post_by_requestObj(self)
        if result['success'] == true
          link = result['link']
          system(`curl '#{link}' -o #{file_path}/#{file_name}`)
        else
          'error'
        end
      end
    end
  end
end
