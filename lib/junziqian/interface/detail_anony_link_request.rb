module Junziqian
  module Interface
    class DetailAnonyLinkRequest < BaseRequest
      attr_accessor :applyNo

      def initialize apply_no
        self.applyNo = apply_no
      end
      def version
        '1.0'
      end

      def method
        'sign.link.anony.detail'
      end

      def ingore_signs
        []
      end

      def query_params
        {applyNo: applyNo}
      end



      def request
        Tool::RequestTool.do_post_by_requestObj(self)
      #   applyNo=APL882159678413475840=> {"link"=> "http://sandbox.junziqian.com/applaySign/toDetailAnony?timestamp=1499160325399&applyNo=APL882159678413475840&sign=a693a313a271b60a53c5c0324f14e7026f89b9f8", "success"=>true}
      end
    end
  end
end
