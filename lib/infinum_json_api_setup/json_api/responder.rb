module InfinumJsonApiSetup
  module JsonApi
    module Responder
      def to_json_api
        if !get? && has_errors?
          display_errors
        else
          display_resource
        end
      end

      private

      def display_resource
        if get? || patch? || put?
          display resource
        elsif post?
          display resource, status: :created
        elsif delete?
          head :no_content
        end
      end

      def json_api_resource_errors
        InfinumJsonApiSetup::Error::UnprocessableEntity.new(object: resource)
      end
    end
  end
end
