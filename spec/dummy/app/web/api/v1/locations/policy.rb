module Api
  module V1
    module Locations
      class Policy < ApplicationPolicy
        # return [Boolean]
        def show?
          record.quadrant == Location::FIRST_QUADRANT
        end
      end
    end
  end
end
