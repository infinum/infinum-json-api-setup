module InfinumJsonApiSetup
  module RSpec
    module Matchers
      # @param [String] type
      # @param [Integer] id
      # @return [InfinumJsonApiSetup::Rspec::Matchers::IncludeRelatedResource]
      def include_related_resource(type, id)
        IncludeRelatedResource.new(type, id)
      end

      class IncludeRelatedResource < JsonBodyMatcher
        # @param [String] type
        # @param [Integer] id
        def initialize(type, id)
          super(Matchers::Util::BodyParser.new('included'))

          @type = type
          @id = id
        end

        private

        attr_reader :id
        attr_reader :included
        attr_reader :pointer
        attr_reader :type

        def body_matches?
          included.one? { |item| item['type'] == type && item['id'].to_i == id }
        end

        def match_failure_message
          "Expected included items to include (type = #{type}, id = #{id}), but didn't"
        end

        def process_parsing_result(result)
          @included = result
        end
      end
    end
  end
end
