module Junziqian
  module Cfg
    class Enum
      # 用户身分证明类型枚举
      IDCARD={"code" => 1, "type" => 0}
      PASSPORT={"code" => 2, "type" => 0}
      MTP={"code" => 3, "type" => 0}
      RTMP={"code" => 4, "type" => 0}
      BIZLIC={"code" => 11, "type" => 1}
      USCC={"code" => 12, "type" => 1}
      OTHER={"code" => 99, "type" => 3}

      # * 验证等级
      USEKEY=1
      BANKCARD=2
      ALIPAY=3
      BANKTHREE=10
      FACE=11

      # * 企业类型
      ENTERPRISE="0"
      PUBLIC_INSTITUTION="1"

      # 签章等级
      GENERAL="0"
      SEAL="1"
      ESIGNSEAL="2"

      #签字状态
      NOTINIT=-1
      INPROGRESS=0
      COMPLETED=1
      REFUSE=2
      PRES=3

      # 合同的处理类型，可以人签，也可以自动签
      DEFAULT="0"
      AUTH_SIGN="1"
      ONLY_PRES="2"
      AUTH_SIGN_PART='5'
    end
  end
end
