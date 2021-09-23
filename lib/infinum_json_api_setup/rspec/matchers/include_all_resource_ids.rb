module InfinumJsonApiSetup
  module RSpec
    module Matchers
      # @param [Array<Integer>] required_ids
      # @return [InfinumJsonApiSetup::Rspec::Matchers::IncludeAllResourceIds]
      def include_all_resource_ids(required_ids)
        IncludeAllResourceIds.new(required_ids)
      end

      class IncludeAllResourceIds < JsonBodyMatcher
        # @param [Array<Integer>] required_ids
        def initialize(required_ids)
          super(Matchers::Util::BodyParser.new('data'))

          @required_ids = process_required_ids(required_ids)
        end

        private

        attr_reader :actual_ids
        attr_reader :required_ids

        def body_matches?
          actual_ids == required_ids
        end

        def match_failure_message
          "Expected response ID's(#{actual_ids}) to match #{required_ids}"
        end

        def process_parsing_result(data)
          @actual_ids = process_actual_ids(
            data.map { |item| process_actual_id(item['id']) }
          )
        end

        def process_required_ids(ids)
          ids.sort
        end

        def process_actual_id(value)
          value.to_i
        end

        def process_actual_ids(ids)
          ids.sort
        end
      end
    end
  end
end
