Mime::Type.register('application/vnd.api+json', :json_api)

ActionDispatch::Request.parameter_parsers[:json_api] = ->(body) do
  JsonApi::ParameterParser.new(
    ActiveSupport::JSON.decode(body)
  ).parameters
end

ActiveSupport.on_load(:action_controller) do
  ActionController::Renderers.add(:json_api) do |resources, opts|
    # Renderer proc is evaluated in the controller context.
    self.content_type ||= Mime[:json_api]

    ActiveSupport::Notifications.instrument('render.json_api', resources: resources, opts: opts) do
      break ::JsonApi::ErrorSerializer.new(resources).serialized_json if resources.is_a?(::HTTP::Error::Base)

      serializer = opts.delete(:serializer) { |key| raise "#{key} not specified" }
      options = JsonApi::SerializerOptions.new(
        params: params.to_unsafe_h, pagination_details: opts[:pagination_details]
      ).build

      serializer.new(resources, options.merge(opts)).serializable_hash.to_json
    end
  end
end
