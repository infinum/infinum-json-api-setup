module InfinumJsonApiSetup
  module Rspec
    module Helpers
      module RequestHelper
        def default_headers
          {
            'content-type' => 'application/vnd.api+json',
            'accept' => 'application/vnd.api+json'
          }
        end

        def json_api_relationships_request_body(relationships)
          json_api_relationship_data(relationships).to_json
        end

        def json_api_request_body(type:, attributes: {}, relationships: {}, included: [], **options)
          {}.tap do |body|
            body[:data] = _data_params(type, attributes, relationships, **options)
            body[:included] = _included_params(included).presence
          end.merge(options).compact.to_json
        end

        def _data_params(type, attributes, relationships, **options)
          attributes = attributes.with_indifferent_access

          {
            type: type,
            id: attributes.delete(:id).to_s,
            attributes: attributes.presence,
            relationships: _relationships_params(relationships).presence
          }.merge(options).compact
        end

        def _included_params(resources)
          resources.reject do |resource|
            resource[:attributes].blank? && resource[:relationships].blank?
          end
        end

        def _relationships_params(relationships)
          relationships.transform_values do |relationship|
            json_api_relationship_data(relationship)
          end
        end

        def json_api_relationship_data(relationship)
          {
            data: case relationship
                  when Array then relationship.map { |rel| rel.slice(:id, :type) }
                  when Hash then relationship.slice(:id, :type)
                  when NilClass then nil
                  else raise ArgumentError 'relationship must be either an array or hash'
                  end
          }
        end

        def json_api_relationship(resource, type: nil)
          if resource.is_a?(Array)
            type = type.presence || _detect_resource_type(resource.first)
            resource.map { |item| json_api_relationship_hash(item.id, type) }
          else
            type = type.presence || _detect_resource_type(resource)
            json_api_relationship_hash(resource.id, type)
          end
        end

        def json_api_relationship_hash(id, type)
          {
            id: id.to_s,
            type: type
          }
        end

        def _detect_resource_type(resource)
          resource.class.name.parameterize.pluralize
        end
      end
    end
  end
end
