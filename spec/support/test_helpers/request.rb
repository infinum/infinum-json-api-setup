module TestHelpers
  module Request
    # @return [Hash]
    def default_headers
      {
        accept: 'application/vnd.api+json',
        'content-type': 'application/vnd.api+json'
      }
    end
  end
end
