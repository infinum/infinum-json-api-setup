module InfinumJsonApiSetup
  module RSpec
    module Matchers
      # @return [InfinumJsonApiSetup::Rspec::Matchers::HaveEmptyData]
      def have_empty_data # rubocop:disable Naming/PredicateName
        HaveEmptyData.new
      end

      class HaveEmptyData
        include MatchJsonData

        private

        def do_matches?
          data.empty?
        end

        def match_failure_message
          "Expected response data(#{data}) to be empty, but isn't"
        end
      end
    end
  end
end
