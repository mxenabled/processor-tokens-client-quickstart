require_relative "../config/environment"
require "rspec/rails"

ENV["RAILS_ENV"] ||= "test"

abort("Rails is running in production mode!") if Rails.env.production?

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
::Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.infer_spec_type_from_file_location!

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.use_active_record = false
end
