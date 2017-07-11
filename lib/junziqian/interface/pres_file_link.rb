module Junziqian
  module Interface
    class PresFileLink < BaseRequest
      attr_accessor :applyNo
      attr_accessor :signatory

      def initialize options
        self.applyNo = options[:apply_no]
        self.signatory = Junziqian::Model::Signatory.new(options[:signatory]).hash_values
      end

      def version
        '1.0'
      end

      def method
        'pres.link.file'
      end

      def ingore_signs
        []
      end

      def query_params
        {applyNo: applyNo, signatory: signatory}
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
          result
        end
      end

      def demo
        hash = {signatory: {userType: Junziqian::Cfg::Enum::IDCARD['type'],
                     identityType: Junziqian::Cfg::Enum::IDCARD['code'],
                     fullName: '张三',
                     identityCard: '360732198908110099'},
         apply_no: 'APL882159678413475840'}
        req = Junziqian::Interface::PresFileLink.new(hash)
      end
    end
  end
end
