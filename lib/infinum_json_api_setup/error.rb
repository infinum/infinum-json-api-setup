module InfinumJsonApiSetup
  module Error
    class Base
      # @return [String]
      attr_reader :details

      # @return [String]
      attr_reader :title

      # @param [Hash] opts
      # @option opts [Object] :object
      # @option opts [String] :message
      def initialize(object: nil, message: nil)
        @details =
          details_from_object(object) || message || I18n.t("json_api.errors.#{http_status}.detail")
        @title = I18n.t("json_api.errors.#{http_status}.title")
      end

      # @return [String]
      def code
        self.class.name.demodulize.underscore.upcase
      end

      # @return [Symbol]
      def http_status
        self.class.name.demodulize.underscore.to_sym
      end

      private

      def details_from_object(object)
        return unless object_supported?(object)

        object.errors.map do |attribute, message|
          [attribute, object.errors.full_message(attribute, message)]
        end
      end

      def object_supported?(object)
        object.present? && object.respond_to?(:errors) && object.errors.is_a?(ActiveModel::Errors)
      end
    end

    class Forbidden < Base; end

    class BadRequest < Base; end

    class Gone < Base; end

    class Unauthorized < Base; end

    class UnprocessableEntity < Base; end

    class RecordNotFound < Base
      # @return [Symbol]
      def http_status
        :not_found
      end
    end
  end
end
