module Api
  module V1
    module Locations
      class Policy < ApplicationPolicy
        # @return [Boolean]
        def show?
          first_quadrant?
        end

        # @return [Boolean]
        def update?
          first_quadrant?
        end

        # @return [Boolean]
        def destroy?
          first_quadrant?
        end

        private

        def first_quadrant?
          record.quadrant == Location::FIRST_QUADRANT
        end
      end
    end
  end
end
