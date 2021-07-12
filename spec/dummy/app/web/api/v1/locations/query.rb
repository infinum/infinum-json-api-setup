module Api
  module V1
    module Locations
      class Query < Jsonapi::QueryBuilder::BaseQuery
        default_sort created_at: :asc

        sorts_by :latitude
        sorts_by :longitude
      end
    end
  end
end
