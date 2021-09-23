module InfinumJsonApiSetup
  module RSpec
    module Matchers
      # @param [Array<Integer>] required_ids
      # @return [InfinumJsonApiSetup::Rspec::Matchers::IncludeAllResourceIdsSorted]
      def include_all_resource_ids_sorted(required_ids)
        IncludeAllResourceIdsSorted.new(required_ids)
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
