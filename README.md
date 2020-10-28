# Infinum JSON:API setup

Preconfigured setup for building JSON:API endpoints

# Installation

Inside your `Gemfile` add the following:

```ruby
gem 'infinum_json_api_setup'
```

# Application configuration
Define responder
```
module Api
  class Responder < ActionController::Responder
    include ::InfinumJsonApiSetup::JsonApi::Responder
  end
end
```
