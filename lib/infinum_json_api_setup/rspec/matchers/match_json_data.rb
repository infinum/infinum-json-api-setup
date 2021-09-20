module InfinumJsonApiSetup
  module RSpec
    module Matchers
      module MatchJsonData
        extend ActiveSupport::Concern

        included do
          attr_reader :response
        end

        # @param [ActionDispatch::TestResponse] response
        # @return [Boolean]
        def matches?(response)
          @response = response
          data

          do_matches?
        rescue JSON::ParserError => _e
          @error_message = 'Failed to parse response body'
          false
        rescue KeyError => _e
          @error_message = 'Failed to extract data from response body'
          false
        end

        # @return [String]
        def failure_message
          @error_message || match_failure_message
        end

        private

        def do_matches?; end

        def match_failure_message; end

        def data
          @data ||= JSON.parse(response.body).fetch('data')
        end
      end
    end
  end
end
