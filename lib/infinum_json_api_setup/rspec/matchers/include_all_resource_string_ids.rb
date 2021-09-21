module InfinumJsonApiSetup
  module RSpec
    module Matchers
      # @param [Array<Integer>] required_ids
      # @return [InfinumJsonApiSetup::Rspec::Matchers::IncludeAllResourceStringIds]
      def include_all_resource_string_ids(required_ids)
        IncludeAllResourceStringIds.new(required_ids)
      end

      class IncludeAllResourceStringIds < IncludeAllResourceIds
        def process_actual_id(id)
          id
        end
      end
    end
  end
end
