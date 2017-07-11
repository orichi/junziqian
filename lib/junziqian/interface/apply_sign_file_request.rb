module Junziqian
  module Interface
    class ApplySignFileRequest < BaseRequest
      # attr_accessor :contractName
      # attr_accessor :serverCa
      # attr_accessor :dealType
      # attr_accessor :file
      # attr_accessor :authenticationLevel
      # attr_accessor :dealType
      # attr_accessor :forceAuthentication
      # attr_accessor :needCa
      # attr_accessor :orderFlag
      # attr_accessor :signLevel
      # attr_accessor :sequenceInfo
      # attr_accessor :
      [:contractName,:serverCa,:dealType,:file,:authenticationLevel,:dealType,:forceAuthentication,:needCa,:orderFlag,:signLevel,:sequenceInfo, :signatories].each do |at|
        attr_accessor at
      end

      def initialize(options)
        tmp = []
        options.each do |k, v|
          if k == :signatories
            options[:signatories].each do |sign|
              tmp << Model::Signatory.new(sign).hash_values
            end
            self.signatories = "[#{tmp.join()}]"
          elsif k == :file
            self.file = Junziqian::Tool::AttacheUtils.new options[:file]
          else
            self.send("#{k}=", v) if self.respond_to?(k)
          end
        end
      end

      def version
        '1.0'
      end

      def content_type
        'multipart/form-data'
      end

      def method
        'sign.apply.file'
      end

      def ignores_params
        [:file]
      end

      def query_params
        #{contractName: contractName, serverCa: serverCa, dealType: dealType, file: file}.merge({signatories: @signatories})
        [:contractName,:serverCa,:dealType,:file,:authenticationLevel,:dealType,:forceAuthentication,:needCa,:orderFlag,:signLevel,:sequenceInfo, :signatories].inject({}) do |hash,item|
          (hash[item] = self.send(item)) if self.send(item).present?
          hash
        end
      end

      def request
        Junziqian::Tool::RequestTool.do_post_by_requestObj(self)
      end

      def demo
        signatories = [{
                           userType: Junziqian::Cfg::Enum::IDCARD['type'],
                           identityType: Junziqian::Cfg::Enum::IDCARD['code'],
                           fullName: '张三',
                           identityCard: '360732198908110099',
                           mobile: '15123649601',
                           signLevel: Junziqian::Cfg::Enum::GENERAL,
                           noNeedVerify: 0,
                           serverCaAuto: 1,
                           orderNum: 1,
                           chapteJson: '['+ {'page' => 0, 'chaptes' => [{"offsetX" => 0.12, "offsetY" => 0.23},{"offsetX" => 0.45, "offsetY" => 0.67}]}.to_json+']'
                       },{userType: Junziqian::Cfg::Enum::BIZLIC['type'],
                          identityType: Junziqian::Cfg::Enum::BIZLIC['code'],
                          fullName: '测试公司',
                          identityCard: '461313456461316',
                          email: '1244268365@qq.com',
                          orderNum: 2,
                          signLevel: Junziqian::Cfg::Enum::SEAL,
                          serverCaAuto: 1,
                          chapteJson: "["+[{'page' => 1,'chaptes' => [{"offsetX" => 0.31, "offsetY" => 0.72},{"offsetX" => 0.72, "offsetY" => 0.72}]}.to_json, {'page' => 2, 'chaptes' => [{"offsetX" => 0.8, "offsetY" => 0.82}]}.to_json].join()+']'
                       }]
        demo1 = {
            file: '/Users/moonless/Documents/demo_contract.pdf',
            contractName: '合同0001',
            signatories: signatories,
            serverCa: 1,
            dealType: Junziqian::Cfg::Enum::AUTH_SIGN,
            orderFlag: 1
        }
        req = Junziqian::Interface::ApplySignFileRequest.new demo1
        #=> {"applyNo"=>"APL882159678413475840", "success"=>true}
        #=> {"applyNo"=>"APL882164292533751808", "success"=>true}
      end
    end
  end
end