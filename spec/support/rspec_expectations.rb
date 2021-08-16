require 'rspec/matchers/fail_matchers'

RSpec.configure do |config|
  config.include RSpec::Matchers::FailMatchers
end
