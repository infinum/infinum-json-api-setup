require 'infinum_json_api_setup/rspec/matchers/schema_matchers'
require 'infinum_json_api_setup/rspec/matchers/body_matchers'
require 'infinum_json_api_setup/rspec/matchers/match_json_data'
require 'infinum_json_api_setup/rspec/matchers/util/body_parser'
require 'infinum_json_api_setup/rspec/matchers/json_body_matcher'
require 'infinum_json_api_setup/rspec/matchers/include_all_resource_ids'
require 'infinum_json_api_setup/rspec/matchers/include_all_resource_string_ids'
require 'infinum_json_api_setup/rspec/matchers/include_all_resource_ids_sorted'
require 'infinum_json_api_setup/rspec/matchers/have_empty_data'
require 'infinum_json_api_setup/rspec/matchers/have_resource_count_of'

require 'infinum_json_api_setup/rspec/helpers/request_helper'
require 'infinum_json_api_setup/rspec/helpers/response_helper'

RSpec.configure do |config|
  config.include InfinumJsonApiSetup::RSpec::Matchers

  config.add_setting :schema_response_root
  config.add_setting :schema_request_root
end
