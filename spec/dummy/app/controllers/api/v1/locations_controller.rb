module Api
  module V1
    class LocationsController < BaseController
      include Pundit

      around_action :with_locale

      # GET /api/v1/locations
      def index
        q = Api::V1::Locations::Query.new(Location.all, params.to_unsafe_hash)

        respond_with q.results
      end

      # GET /api/v1/locations
      def create
        location = Location.create(permitted_params)

        respond_wih location
      end

      # GET /api/v1/locations/:id
      def show
        location = authorize(Location.find(params[:id]))

        respond_with location
      end

      private

      def with_locale(&block)
        I18n.with_locale(params.fetch(:locale, :en), &block)
      end

      def permitted_params
        params.require(:location).permit(:latitude, :longitude)
      end

      def authorize(record)
        super(record, policy_class: Api::V1::Locations::Policy)
      end

      def pundit_user
        nil
      end
    end
  end
end
