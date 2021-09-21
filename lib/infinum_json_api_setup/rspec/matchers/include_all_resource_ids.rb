require 'json'

module InfinumJsonApiSetup
  module RSpec
    module Matchers
      # @return [InfinumJsonApiSetup::Rspec::Matchers::IncludeAllResourceIds]
      def include_all_resource_ids(*args)
        IncludeAllResourceIds.new(*args)
      end

      class IncludeAllResourceIds
        include MatchJsonData

        # @param [Array<Integer>] required_ids
        def initialize(required_ids)
          @required_ids = process_required_ids(required_ids)
        end

        private

        def do_matches?
          actual_ids == required_ids
        end

        attr_reader :required_ids

        def match_failure_message
          "Expected response ID's(#{actual_ids}) to match #{required_ids}"
        end

        def process_required_ids(ids)
          ids.sort
        end

        def actual_ids
          @actual_ids ||= process_actual_ids(
            data.map { |resource| process_actual_id(resource['id']) }
          )
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
