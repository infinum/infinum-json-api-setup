module InfinumJsonApiSetup
  module JsonApi
    class ParameterParser
      include JsonApi::Parameters

      def initialize(parameters)
        @parameters = parameters
      end

      def parameters
        jsonapify(@parameters)
      end
    end
  end
end
