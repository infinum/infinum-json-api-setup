module InfinumJsonApiSetup
  module Rspec
    module Helpers
      module ResponseHelper
        def json_response
          JSON.parse(response.body, symbolize_names: true)
        end

        def response_item
          raise 'json response is not an item' if json_response[:data].is_a?(Array)

          OpenStruct.new(json_response[:data][:attributes]) # rubocop:disable Style/OpenStructUse
        end

        def response_collection
          raise 'json response is not a collection' unless json_response[:data].is_a?(Array)

          json_response[:data].map do |item|
            OpenStruct.new(id: item[:id], type: item[:type], **item[:attributes]) # rubocop:disable Style/OpenStructUse
          end
        end

        def response_relationships(response_type: :item)
          case response_type
          when :item then json_response.dig(:data, :relationships)
          when :collection then json_response[:data].pluck(:relationships)
          else raise ArgumentError ':response_type must be one of [:item, :collection]'
          end
        end

        def response_meta
          json_response[:meta]
        end

        def response_included
          json_response[:included].map do |item|
            OpenStruct.new(id: item[:id], type: item[:type], **item[:attributes]) # rubocop:disable Style/OpenStructUse
          end
        end

        def response_included_relationship(name)
          data = response_relationships.fetch(name)[:data]

          return if data.nil?

          relationship_id, relationship_type =
            response_relationships.fetch(name)[:data].values_at(:id, :type)

          response_included.find do |object|
            object.id == relationship_id && object.type == relationship_type
          end
        end
      end
    end
  end
end
