module InfinumJsonApiSetup
  module RSpec
    module Matchers
      # @param [String] pointer
      # @return [InfinumJsonApiSetup::Rspec::Matchers::HaveErrorPointer]
      def have_error_pointer(pointer) # rubocop:disable Naming/PredicateName
        HaveErrorPointer.new(pointer)
      end

      class HaveErrorPointer < JsonBodyMatcher
        # @param [String] pointer
        def initialize(pointer)
          super(Matchers::Util::BodyParser.new('errors'))

          @pointer = pointer
        end

        private

        attr_reader :pointer
        attr_reader :errors

        def body_matches?
          errors.any? { |error| error.dig('source', 'pointer') == pointer }
        end

        def match_failure_message
          "Expected error pointers to include '#{pointer}', but didn't"
        end

        def process_parsing_result(result)
          @errors = result
        end
      end
    end
  end
end
