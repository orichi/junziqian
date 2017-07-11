module Junziqian
  module Interface
    class SignStatusRequest < BaseRequest
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
        'sign.status'
      end

      def ingore_signs
        []
      end

      def query_params
        {applyNo: applyNo, signatory: signatory}
      end



      def request
        result = Tool::RequestTool.do_post_by_requestObj(self)
        if result['success'] == true
          [result['signStatus'], trans_signstatus(result['signStatus'])]
        else
          result
        end
      end

      def trans_signstatus status_int
        #1 已签、2 拒签、3 保全
        {1=>'已签', 2=>'拒签', 3=>'保全'}[status_int]
      end

      def demo
        hash = {signatory: {userType: Junziqian::Cfg::Enum::IDCARD['type'],
                            identityType: Junziqian::Cfg::Enum::IDCARD['code'],
                            fullName: '张三',
                            identityCard: '360732198908110099'},
                apply_no: 'APL882159678413475840'}
        req = Junziqian::Interface::SignStatusRequest.new(hash)
      end
    end
  end
end
