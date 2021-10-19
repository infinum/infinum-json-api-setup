# Infinum JSON:API setup
Preconfigured set of libraries for building JSON:API compliant endpoints, with matchers for writing more declarative JSON:API specs. This library presumes host project is compliant with using
- [rails](https://github.com/rails/rails) as an application server
- [jsonapi_parameters](https://github.com/visualitypl/jsonapi_parameters) for incoming data parsing
- [json_schemer](https://github.com/davishmcclurg/json_schemer) for validating JSON structures
- [responders](https://github.com/heartcombo/responders) for writing declarative actions

## Installation
1. Add Infinum JSON:API setup to your Gemfile
  ```ruby
  gem 'infinum_json_api_setup'
  ```

2. Next, run the generator
  ```bash
  bundle exec rails generate infinum_json_api_setup:install
  ```
The generator will copy the [default translations](https://github.com/infinum/infinum-json-api-setup/blob/master/lib/generators/infinum_json_api_setup/templates/config/locales/json_api.en.yml) into the host project (`config/locales/json_api.en.yml`), where they can be customized.

## Application configuration
Create abstract class for your controllers, include common JSON:API request processing behaviour, and configure responders.
```ruby
module Api
  class BaseController < ActionController::API
    include InfinumJsonApiSetup::JsonApi::ErrorHandling
    include InfinumJsonApiSetup::JsonApi::ContentNegotiation

    self.responder = InfinumJsonApiSetup::JsonApi::Responder
    respond_to :json_api
  end
end
```

## Basic usage

### Permitted parameter handling
Use [jsonapi_parameters](https://github.com/visualitypl/jsonapi_parameters) to transform incoming JSON:API compliant data into common Rails parameters
```ruby
def permitted_params
  params.from_jsonapi
        .require(:user)
        .permit(:first_name, :last_name)
end
```

### Responding
Use `respond_with` to initiate transformation (serialization) of domain objects into HTTP response.
```ruby
def show
  respond_with User.find(params[:id])
end
```

`respond_with` is well integrated with `ActiveRecord::Model` interface. Given a compliant object, the method will correctly set a response status and handle object(or error) serialization based on the presence of `.errors`. For a successful domain operation, HTTP status will be 200 OK (or 201 in case of `create` controller action). Unsuccessful operations will have HTTP status 422 Unprocessable Entity with errors structured according to [JSON:API specification](https://jsonapi.org/format/#error-objects).
```ruby
def create
  respond_with User.create(permitted_params)
end
```

`respond_with` also detects usage from a `destroy` controller action and responds with HTTP status 204 No Content and an empty body.
```ruby
def destroy
  respond_with User.destroy(params[:id])
end
```

## Internals
This section explains the under-the-hood behavior of the library.

### Content negotiation
`InfinumJsonApiSetup::JsonApi::ContentNegotiation` module is designed to integrate [server responsibilities](https://jsonapi.org/format/#content-negotiation-servers) of content negotiation protocol described by the JSON:API specification.

### Error handling
`InfinumJsonApiSetup::JsonApi::ErrorHandling` module is designed to catch and handle common exceptions that might bubble up when processing a request.

| Exception                                      | HTTP status | Bugsnag notification |
| ---                                            | :---:       | :---:                |
| `ActionController::ParameterMissing`           | 400         |                      |
| `ActionDispatch::Http::Parameters::ParseError` | 400         |                      |
| `Jure::UnpermittedSortParameters`              | 400         | :white_check_mark:   |
| `I18n::InvalidLocale`                          | 400         |                      |
| `Pundit::NotAuthorizedError`                   | 403         | :white_check_mark:   |
| `ActiveRecord::RecordNotFound`                 | 404         |                      |
| `PG::Error`                                    | 500         |                      |

### Error serialization
`InfinumJsonApiSetup::JsonApi::ErrorSerializer` is responsible for serializing domain errors according to [JSON:API specification](https://jsonapi.org/format/#error-objects).

## Testing

### RSpec configuration
Library ships with a set of declarative matchers and request/response helpers. To use them in your specs, configure your RSpec setup in the following way which
- includes all defined matchers
- includes request and response helper methods into specs tagged with `:request` metadata
- configures search paths for resolving JSON schema files
```ruby
require 'infinum_json_api_setup/rspec'

RSpec.configure do |config|
  # Helpers
  config.include InfinumJsonApiSetup::Rspec::Helpers::RequestHelper, type: :request
  config.include InfinumJsonApiSetup::Rspec::Helpers::ResponseHelper, type: :request

  # Schema paths
  config.schema_response_root = Rails.application.root.join('path/to/response_schemas')
  config.schema_request_root = Rails.application.root.join('path/to/request_schemas')
end
```
### Matchers

#### Have empty data
```ruby
expect(response).to have_empty_data
```

#### Have error pointer
```ruby
expect(response).to have_error_pointer('data/attributes/first_name')
```

#### Have resource count of
```ruby
expect(response).to have_resource_count_of(3)
```

#### Include all resource ids
```ruby
expect(response).to include_all_resource_ids(records.map(&:id))
```

#### Include all resource ids sorted
```ruby
expect(response).to include_all_resource_ids_sorted(records.map(&:id))
```

#### Include all resource string ids
```ruby
expect(response).to include_all_resource_string_ids(records.map(&:id).map(&:to_s))
```

#### Include error detail
```ruby
expect(response).to include_error_detail('name has been taken')
```

#### Include related resource
```ruby
expect(response).to include_related_resource('user', user.id)
```

## Credits
**JSON:API setup** is maintained and sponsored by [Infinum](https://infinum.co)

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
