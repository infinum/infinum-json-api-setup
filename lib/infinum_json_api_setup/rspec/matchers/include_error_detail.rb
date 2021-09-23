module InfinumJsonApiSetup
  module RSpec
    module Matchers
      # @param [String] error_detail
      # @return [InfinumJsonApiSetup::Rspec::Matchers::IncludeErrorDetail]
      def include_error_detail(error_detail)
        IncludeErrorDetail.new(error_detail)
      end

      class IncludeErrorDetail < JsonBodyMatcher
        # @param [String] error_detail
        def initialize(error_detail)
          super(Matchers::Util::BodyParser.new('errors'))

          @error_detail = error_detail
        end

        private

        attr_reader :error_detail
        attr_reader :errors

        def body_matches?
          errors.any? { |error| error['detail'].include?(error_detail) }
        end

        def match_failure_message
          "Expected error details to include '#{error_detail}', but didn't"
        end

        def process_parsing_result(result)
          @errors = result
        end
      end
    end
  end
end
