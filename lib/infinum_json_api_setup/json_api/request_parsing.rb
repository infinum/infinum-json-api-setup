module InfinumJsonApiSetup
  module JsonApi
    module RequestParsing
      def relationship_children_ids(type)
        data_params.map do |p|
          next if p[:type] != type

          p[:id].to_i
        end.compact.uniq
      end

      def data_params
        params.to_unsafe_hash[:data]
      end
    end
  end
end
