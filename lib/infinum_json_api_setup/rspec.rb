require 'infinum_json_api_setup/rspec/matchers/schema_matchers'
require 'infinum_json_api_setup/rspec/matchers/body_matchers'

require 'infinum_json_api_setup/rspec/helpers/request_helper'
require 'infinum_json_api_setup/rspec/helpers/response_helper'

RSpec.configure do |config|
  config.add_setting :schema_response_root
  config.add_setting :schema_request_root
end
