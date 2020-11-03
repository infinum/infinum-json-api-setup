module InfinumJsonApiSetup
  module JsonApi
    module ErrorHandling
      extend ActiveSupport::Concern

      included do
        rescue_from ActionController::ParameterMissing do |e|
          render_error(InfinumJsonApiSetup::Error::BadRequest.new(message: e.to_s))
        end

        rescue_from ActiveRecord::RecordNotFound do
          render_error(InfinumJsonApiSetup::Error::RecordNotFound.new)
        end

        if defined?(Pundit)
          rescue_from Pundit::NotAuthorizedError do
            message = 'You are not allowed to perform this action'
            render_error(InfinumJsonApiSetup::Error::Forbidden.new(message: message))
          end
        end

        if defined?(Jsonapi::QueryBuilder)
          rescue_from Jsonapi::QueryBuilder::Mixins::Sort::UnpermittedSortParameters do |e|
            render_error(InfinumJsonApiSetup::Error::BadRequest.new(message: e.to_s))
          end
        end

        # we don't want to expose internal details to API consumer
        rescue_from PG::Error do |e|
          Bugsnag.notify(e)
          render_error(InfinumJsonApiSetup::Error::InternalServerError.new)
        end

        rescue_from I18n::InvalidLocale do |e|
          render_error(InfinumJsonApiSetup::Error::BadRequest.new(message: e.to_s))
        end
      end

      def render_error(error)
        render json_api: error, status: error.http_status
      end
    end
  end
end
