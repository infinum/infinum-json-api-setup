module InfinumJsonApiSetup
  module Rspec
    module Helpers
      module RequestHelper
        def json_api_params(type:, attributes: {}, relationships: {}, included: [], **options)
          {}.tap do |body|
            body[:data] = _serialized_params(type, attributes, **options)
            if relationships.present?
              body[:data][:relationships] = _relationships_params(relationships)
            end

            body[:included] = json_api_included(included) if included.present?
          end.merge(options).compact.to_json
        end

        def json_api_relationship(resource, type: nil)
          if resource.is_a?(Array)
            type = type.presence || _detect_resource_type(resource.first)
            resource.map { |item| json_api_relationship_params(item.id, type) }
          else
            type = type.presence || _detect_resource_type(resource)
            json_api_relationship_params(resource.id, type)
          end
        end

        def json_api_relationship_params(id, type)
          {
            id: id.to_s,
            type: type
          }
        end

        def json_api_included(relationships)
          relationships.reject { |relationship| relationship[:attributes].blank? }.presence
        end

        def default_headers
          {
            'content-type' => 'application/vnd.api+json',
            'accept' => 'application/vnd.api+json'
          }
        end

        def _serialized_params(type, attributes, **options)
          attributes = attributes.with_indifferent_access

          {
            type: type,
            id: attributes.delete(:id).to_s,
            attributes: attributes.presence
          }.merge(options).compact
        end

        def _detect_resource_type(resource)
          resource.class.name.parameterize.pluralize
        end

        def json_api_relationships_params(relationships)
          _relationship_data(relationships).to_json
        end

        def _relationships_params(relationships)
          relationships.transform_values do |relationship|
            _relationship_data(relationship)
          end
        end

        def _relationship_data(relationship)
          {
            data: case relationship
                  when Array then relationship.map { |rel| rel.slice(:id, :type) }
                  when Hash then relationship.slice(:id, :type)
                  else raise ArgumentError 'relationship must be either an array or hash'
                  end
          }
        end
      end
    end
  end
end
