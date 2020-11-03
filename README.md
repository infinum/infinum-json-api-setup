# Infinum JSON:API setup

Preconfigured setup for building JSON:API endpoints

# Installation

Add infinum JSON:API setup gem to your Gemfile:
```ruby
gem 'infinum_json_api_setup'
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
  end
end
```
