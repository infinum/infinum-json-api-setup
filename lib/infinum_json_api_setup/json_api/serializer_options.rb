module InfinumJsonApiSetup
  module JsonApi
    class SerializerOptions
      # @param [Hash] opts
      # @option opts [Hash] :params
      # @option opts [Object] :pagination_details
      def initialize(params:, pagination_details:)
        @params = params
        @pagination_details = pagination_details
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

      attr_reader :params, :pagination_details

      def meta
        return {} unless pagination_details

        {
          current_page: pagination_details.page,
          total_pages: pagination_details.pages,
          total_count: pagination_details.count,
          padding: pagination_details.vars.fetch(:outset).to_i,
          max_page_size: Pagy::VARS[:max_items]
        }
      end

      def links
        return {} unless pagination_details

        {
          self: build_link(pagination_details.page),
          first: build_link(1),
          last: build_link(pagination_details.last),
          prev: build_link(pagination_details.prev),
          next: build_link(pagination_details.next)
        }.compact
      end

      def build_link(page)
        return unless page

        link_params = params.deep_dup
        link_params[:page] = {
          number: page,
          size: pagination_details.items,
          padding: pagination_details.vars[:outset]
        }.compact

        Rails.application.routes.url_helpers.url_for(link_params)
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
