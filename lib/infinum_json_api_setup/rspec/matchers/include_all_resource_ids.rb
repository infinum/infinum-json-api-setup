require 'json'

module InfinumJsonApiSetup
  module RSpec
    module Matchers
      # @return [InfinumJsonApiSetup::Rspec::Matchers::IncludeAllResourceIds]
      def include_all_resource_ids(*args)
        IncludeAllResourceIds.new(*args)
      end

      class IncludeAllResourceIds
        # @param [Array<Integer>] required_ids
        def initialize(required_ids)
          @required_ids = required_ids.sort
        end

        # @param [ActionDispatch::TestResponse] response
        # @return [Boolean]
        def matches?(response)
          @response = response

          actual_ids == required_ids.sort
        rescue JSON::ParserError => _e
          @error_message = 'Failed to parse response body'
          false
        rescue KeyError => _e
          @error_message = 'Failed to extract data from response body'
          false
        end

        # @return [String]
        def failure_message
          @error_message || "Expected response ID's(#{actual_ids}) to match #{required_ids}"
        end

        private

        attr_reader :response
        attr_reader :required_ids

        def actual_ids
          @actual_ids ||= JSON
                          .parse(response.body)
                          .fetch('data')
                          .map { |resource| process_id(resource['id']) }
                          .sort
        end

        def process_id(value)
          value.to_i
        end
      end
    end
  end
end
