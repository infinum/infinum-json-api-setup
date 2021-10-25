require File.expand_path('./lib/infinum_json_api_setup/version', __dir__)

Gem::Specification.new do |s|
  s.name        = 'infinum_json_api_setup'
  s.version     = InfinumJsonApiSetup::VERSION
  s.summary     = 'Infinum JSON:API setup'
  s.description = 'Preconfigured setup for building JSON:API endpoints'
  s.authors     = ['Team Backend @ Infinum']
  s.email       = 'team.backend@infinum.com'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/infinum/infinum-json-api-setup'
  s.license     = 'MIT'
  s.required_ruby_version = '> 2.7'

  s.add_runtime_dependency 'jsonapi_parameters'
  s.add_runtime_dependency 'jsonapi-query_builder'
  s.add_runtime_dependency 'jsonapi-serializer'
  s.add_runtime_dependency 'json_schemer', '~> 0.2'
  s.add_runtime_dependency 'pagy'
  s.add_runtime_dependency 'rails'
  s.add_runtime_dependency 'responders'

  s.add_development_dependency 'overcommit', '~> 0.58'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'pry-rails'
  s.add_development_dependency 'pundit'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec-rails', '~> 5.0'
  s.add_development_dependency 'simplecov'
end
