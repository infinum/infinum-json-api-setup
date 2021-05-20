Mime::Type.register('application/vnd.api+json', :json_api)

ActionDispatch::Request.parameter_parsers[:json_api] = lambda do |body|
  ActiveSupport::JSON.decode(body)
end

ActiveSupport.on_load(:action_controller) do
  ActionController::Renderers.add(:json_api) do |resources, opts|
    # Renderer proc is evaluated in the controller context.
    self.content_type ||= Mime[:json_api]

    ActiveSupport::Notifications.instrument('render.json_api', resources: resources, opts: opts) do
      if resources.is_a?(InfinumJsonApiSetup::Error::Base)
        break InfinumJsonApiSetup::JsonApi::ErrorSerializer.new(resources).serialized_json
      end
      break if opts[:status] == 204

      serializer = opts.delete(:serializer) do
        "#{controller_path.classify.pluralize}::Serializer".constantize
      end
      options = InfinumJsonApiSetup::JsonApi::SerializerOptions.new(
        params: params.to_unsafe_h,
        serializer_options: opts.delete(:serializer_options) { {} }
      ).build

      serializer.new(resources, options.merge(opts)).serializable_hash.to_json
    end
  end
end
