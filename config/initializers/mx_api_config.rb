# frozen_string_literal: true

# Set up our app to use the Client ID and API Key from the MX Client Dashboard
# https://dashboard.mx.com

Rails.logger.info('... Loading MX Configuration ...')

::MxPlatformRuby.configure do |config|
  # Configure with your Client ID/API Key from https://dashboard.mx.com
  config.username = ENV['MX_CLIENT_ID']
  config.password = ENV['MX_API_KEY']

  # Configure environment. 0 for production, 1 for development
  config.server_index = 1
end

# Where you want to use the api, you create a new client
# api_client = ::MxPlatformRuby::ApiClient.new
# api_client.default_headers['Accept'] = 'application/vnd.mx.api.v1+json'
# mx_platform_api = ::MxPlatformRuby::MxPlatformApi.new(api_client)

Rails.logger.info('... MX Configured! ...')
