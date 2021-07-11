module Api
  module V1
    class LocationsController < BaseController
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

      def permitted_params
        params.require(:location).permit(:latitude, :longitude)
      end
    end
  end
end
