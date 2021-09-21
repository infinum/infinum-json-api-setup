module InfinumJsonApiSetup
  module RSpec
    module Matchers
      # @return [InfinumJsonApiSetup::Rspec::Matchers::HaveResourceCountOf]
      def have_resource_count_of(*args) # rubocop:disable Naming/PredicateName
        HaveResourceCountOf.new(*args)
      end

      class HaveResourceCountOf
        include MatchJsonData

        # @param [Integer] expected_count
        def initialize(expected_count)
          @expected_count = expected_count
        end

        private

        attr_reader :expected_count

        def do_matches?
          data.length == expected_count
        end

        def match_failure_message
          "Expected response data to have #{expected_count} items, but had #{data.length}"
        end
      end
    end
  end
end
