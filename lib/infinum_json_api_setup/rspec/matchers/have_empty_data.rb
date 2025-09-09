module InfinumJsonApiSetup
  module RSpec
    module Matchers
      # @return [InfinumJsonApiSetup::Rspec::Matchers::HaveEmptyData]
      def have_empty_data # rubocop:disable Naming/PredicatePrefix
        HaveEmptyData.new
      end

      class HaveEmptyData < JsonBodyMatcher
        def initialize
          super(Matchers::Util::BodyParser.new('data'))
        end

        private

        attr_reader :data

        def body_matches?
          data.empty?
        end

        def match_failure_message
          "Expected response data(#{data}) to be empty, but isn't"
        end

        def process_parsing_result(data)
          @data = data
        end
      end
    end
  end
end
