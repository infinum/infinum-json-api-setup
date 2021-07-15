module Api
  module V1
    module Locations
      class LabelSerializer
        include JSONAPI::Serializer

        attribute :title
        attribute :created_at
        attribute :updated_at
      end
    end
  end
end
