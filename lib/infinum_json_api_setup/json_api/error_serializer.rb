module InfinumJsonApiSetup
  module JsonApi
    class ErrorSerializer
      # @return [Object]
      attr_reader :error

      # @return [String]
      delegate :details, to: :error

      # @param [Object]
      def initialize(error)
        @error = error
      end

      # @param [String]
      def serialized_json
        ActiveSupport::JSON.encode(serializable_hash)
      end

      # @param [Hash]
      def serializable_hash
        {}.tap do |hash|
          hash[:errors] = error.details.is_a?(Array) ? serialize_error_array : serialize_error_message
        end
      end

      private

      def serialize_error_array
        details.map do |attribute, message|
          {
            status: error.http_status.to_s.humanize(capitalize: false),
            code: error.code,
            title: I18n.t("json_api.errors.#{error.http_status}.title"),
            detail: message,
            source: serialize_source(attribute)
          }
        end
      end

      def serialize_source(attribute)
        # examples:
        #   'attribute_name'.match(/(?:(.+)\.)?([^.]+\z)/).to_a
        #   # => ["attribute_name", nil, "attribute_name"]
        #   'relationship.attribute_name'.match(/(?:(.+)\.)?([^.]+\z)/).to_a
        #   # => ["relationship.attribute_name", "relationship", "attribute_name"]
        parameter, relationship, attribute = attribute.match(/(?:(.+)\.)?([^.]+\z)/).to_a

        {}.tap do |hash|
          hash[:parameter] = parameter
          hash[:pointer] = if relationship
                             "data/attributes/#{relationship}_attributes/#{attribute}"
                           else
                             "data/attributes/#{attribute}"
                           end
        end
      end

      def serialize_error_message
        [
          {
            status: error.http_status.to_s.humanize(capitalize: false),
            code: error.code,
            title: I18n.t("json_api.errors.#{error.http_status}.title"),
            detail: details
          }
        ]
      end
    end
  end
end
