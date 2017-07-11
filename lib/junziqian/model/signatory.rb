module Junziqian
  module Model
    class Signatory
      [:userType, :fullName, :identityType, :identityCard, :mobile, :email, :address, :authLeve, :authenticationLevel, :authLevel, :authLevelRange, :forceAuthentication, :signLevel, :forceEvidence, :chapteJson, :noNeedEvidence, :orderNum, :insureYear, :noNeedVerify, :serverCaAuto, :readTime].each do |at|
        attr_accessor at
      end


      def initialize options= {}
        options.each do |k, v|
          if self.respond_to?(k)
            self.send("#{k}=", v)
          end
        end
      end

      def hash_values
        [:userType, :fullName, :identityType, :identityCard, :mobile, :email, :address, :authLeve, :authenticationLevel, :authLevel, :authLevelRange, :forceAuthentication, :signLevel, :forceEvidence, :chapteJson, :noNeedEvidence, :orderNum, :insureYear, :noNeedVerify, :serverCaAuto, :readTime].inject({}) do |hash, item|
          hash[item] = self.send(item)
          hash
        end.to_json
      end
    end
  end
end
