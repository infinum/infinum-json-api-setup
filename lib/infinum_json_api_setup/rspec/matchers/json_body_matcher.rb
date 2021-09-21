module InfinumJsonApiSetup
  module RSpec
    module Matchers
      class JsonBodyMatcher
        def initialize(parser)
          @parser = parser
        end

        # @param [ActionDispatch::TestResponse] response
        # @return [Boolean]
        def matches?(response)
          @response = response
          success, result = parser.process(response)

          if success
            process_parsing_result(result)
            body_matches?
          else
            @error_message = result
            false
          end
        end

        # @return [String]
        def failure_message
          @error_message || match_failure_message
        end

        private

        attr_reader :parser
        attr_reader :response

        def body_matches?; end

        def match_failure_message; end

        def process_parsing_result(_result); end
      end
    end
  end
end
