module InfinumJsonApiSetup
  module RSpec
    module Matchers
      # @return [InfinumJsonApiSetup::Rspec::Matchers::IncludeAllResourceStringIds]
      def include_all_resource_string_ids(*args)
        IncludeAllResourceStringIds.new(*args)
      end

      class IncludeAllResourceStringIds < IncludeAllResourceIds
        def process_actual_id(id)
          id
        end
      end
    end
  end
end
