require 'rails'

require 'json'
require 'jsonapi_parameters'
require 'jsonapi/serializer'
require 'json_schemer'
require 'responders'

require 'pagy'
require 'jsonapi/query_builder'

require 'infinum_json_api_setup/error'
require 'infinum_json_api_setup/json_api/error_handling'
require 'infinum_json_api_setup/json_api/error_serializer'

require 'infinum_json_api_setup/json_api/content_negotiation'
require 'infinum_json_api_setup/json_api/locale_negotiation'
require 'infinum_json_api_setup/json_api/request_parsing'
require 'infinum_json_api_setup/json_api/serializer_options'
require 'infinum_json_api_setup/json_api/responder'

require 'infinum_json_api_setup/rails'
