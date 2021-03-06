# Infinum JSON:API setup

Preconfigured setup for building JSON:API endpoints

# Installation

Add infinum JSON:API setup gem to your Gemfile:
```ruby
gem 'infinum_json_api_setup', github: 'infinum/infinum-json-api-setup'
```

Next, run the generator:
```bash
$> rails generate infinum_json_api_setup:install
```

# Application configuration
```
module Api
  class BaseController < ActionController::API
    include InfinumJsonApiSetup::JsonApi::ErrorHandling
    include InfinumJsonApiSetup::JsonApi::ContentNegotiation

    self.responder = InfinumJsonApiSetup::JsonApi::Responder
    respond_to :json_api
  end
end
```

# RSpec configuration

spec/support/infinum_json_api_setup.rb

```
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
