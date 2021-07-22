module InfinumJsonApiSetup
  module JsonApi
    class SerializerOptions
      # @param [Hash] opts
      # @option opts [Hash] :params
      # @option opts [Object] :serializer_options
      def initialize(params:, serializer_options:)
        @params = params
        @serializer_options = serializer_options
      end

      # @return [Hash]
      def build
        {
          meta: meta,
          links: links,
          fields: fields,
          include: include
        }.compact
      end

      private

      attr_reader :params, :serializer_options

      def meta
        serializer_options[:meta]
      end

      def links
        serializer_options[:links]
      end

      def fields
        return nil unless params[:fields]

        params[:fields].transform_values { |fields| fields.split(',') }
      end

      def include
        params[:include]&.split(',')
      end
    end
  end
end
