module Api
  module V1
    module Locations
      class Serializer
        include JSONAPI::Serializer

        has_many :labels, serializer: LabelSerializer
        attribute :latitude
        attribute :longitude
        attribute :created_at
        attribute :updated_at
      end
    end
  end
end
