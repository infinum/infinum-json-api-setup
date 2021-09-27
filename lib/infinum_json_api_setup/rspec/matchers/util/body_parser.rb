require 'json'

module InfinumJsonApiSetup
  module RSpec
    module Matchers
      module Util
        class BodyParser
          # @param [String] attribute
          def initialize(attribute)
            @attribute = attribute
          end

          # @param [ActionDispatch::TestResponse] response
          # @return [Array]
          def process(response)
            [true, JSON.parse(response.body).fetch(attribute)]
          rescue JSON::ParserError => _e
            [false, 'Failed to parse response body']
          rescue KeyError => _e
            [false, "Failed to extract #{attribute} from response body"]
          end

          private

          attr_reader :attribute
        end
      end
    end
  end
end
