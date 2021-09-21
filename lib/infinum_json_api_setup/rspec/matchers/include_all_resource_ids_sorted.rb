module InfinumJsonApiSetup
  module RSpec
    module Matchers
      # @return [InfinumJsonApiSetup::Rspec::Matchers::IncludeAllResourceIdsSorted]
      def include_all_resource_ids_sorted(*args)
        IncludeAllResourceIdsSorted.new(*args)
      end

      class IncludeAllResourceIdsSorted < IncludeAllResourceIds
        def process_required_ids(ids)
          ids
        end

        def process_actual_ids(ids)
          ids
        end
      end
    end
  end
end
