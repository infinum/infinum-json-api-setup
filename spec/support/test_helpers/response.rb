module TestHelpers
  module Response
    # @return [Hash]
    def json_response
      JSON.parse(response.body)
    end
  end
end
