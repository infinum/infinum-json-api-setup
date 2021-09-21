module TestHelpers
  module Matchers
    module Response
      # @param [Array<Object>] ids
      # @return [ActionDispatch::TestResponse]
      def response_with_ids(ids)
        response_with_body(JSON.dump(data: ids.map { |id| { 'id' => id } }))
      end

      # @param [String] body
      # @return [ActionDispatch::TestResponse]
      def response_with_body(body)
        ActionDispatch::TestResponse.new(200, {}, body)
      end
    end
  end
end
