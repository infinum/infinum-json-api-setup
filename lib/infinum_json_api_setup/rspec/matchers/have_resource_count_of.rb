module InfinumJsonApiSetup
  module RSpec
    module Matchers
      # @param [Integer] expected_count
      # @return [InfinumJsonApiSetup::Rspec::Matchers::HaveResourceCountOf]
      def have_resource_count_of(expected_count) # rubocop:disable Naming/PredicateName
        HaveResourceCountOf.new(expected_count)
      end

      class HaveResourceCountOf < JsonBodyMatcher
        # @param [Integer] expected_count
        def initialize(expected_count)
          super(Matchers::Util::BodyParser.new('data'))

          @expected_count = expected_count
        end

        private

        attr_reader :data
        attr_reader :expected_count

        def body_matches?
          data.length == expected_count
        end

        def match_failure_message
          "Expected response data to have #{expected_count} items, but had #{data.length}"
        end

        def process_parsing_result(data)
          @data = data
        end
      end
    end
  end
end
