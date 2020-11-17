module InfinumJsonApiSetup
  module JsonApi
    module ContentNegotiation
      extend ActiveSupport::Concern

      included do
        before_action :validate_jsonapi_request
      end

      def validate_jsonapi_request
        if !acceptable?
          head :not_acceptable
        elsif !valid_content_type?
          head :unsupported_media_type
        end
      end

      def valid_content_type?
        return true if request.body.length.zero?

        request.content_type == Mime.fetch(:json_api)
      end

      def acceptable?
        request.accept&.split(',')&.include?(Mime.fetch(:json_api))
      end
    end
  end
end
