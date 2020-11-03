RSpec::Matchers.define :match_response_schema do |schema|
  match do |response|
    schema_path = RSpec.configuration.schema_response_root.join("#{schema}.json")
    schemer = JSONSchemer.schema(schema_path)

    @errors = schemer.validate(JSON.parse(response.body))

    @errors.none?
  end

  failure_message do |_|
    @errors.map { |error| JSONSchemer::Errors.pretty error }
  end
end

RSpec::Matchers.define :match_request_schema do |schema|
  match do |request|
    schema_path = RSpec.configuration.schema_request_root.join("#{schema}.json")
    schemer = JSONSchemer.schema(schema_path)

    @errors = schemer.validate(JSON.parse(request.body.readpartial))

    @errors.none?
  end

  failure_message do |_|
    @errors.map { |error| JSONSchemer::Errors.pretty error }
  end
end
