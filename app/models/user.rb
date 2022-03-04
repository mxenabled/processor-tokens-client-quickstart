# frozen_string_literal: true

# Note - not a rails model, just a custom class

# A simple model that describes a few User fields
class User
  attr_accessor :name, :email, :guid

  def initialize(user_values_hash = {})
    name, email, guid = user_values_hash.values_at(:name, :email, :guid)
    @name = name
    @email = email
    @guid = guid
  end

  # Returns the guid
  def create_external_user
    mx_platform_api = ::MxApi.new

    metadata_hash = { name: @name }
    response = mx_platform_api.create_user(metadata_hash.to_json, @email)

    puts 'Error: creation of MX user failed' unless response.user.guid

    response.user.guid
  end

  # Get a single user from the api
  # @return nil | User
  def self.get_user(user_guid)
    mx_platform_api = ::MxApi.new

    api_response = mx_platform_api.read_user(user_guid)

    if !api_response.success
      return nil
    end

    # Adapt to the application's expected model
    MxHelper::UserAdapter.api_to_user_model(api_response.response.user)
  end
end
