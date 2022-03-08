# frozen_string_literal: true

# MX provides many features through the Platform API, documented at https://docs.mx.com.
#
# This file (mx_api.rb) houses the implementations of a few of those endpoints using an
# open source gem built with the MX OpenAPI
# see: https://github.com/mxenabled/mx-platform-ruby and https://github.com/mxenabled/openapi
#
# For this app, there is also an initializer that configures the authentication for each call
# see: config/initializers/mx_api_config.rb

# Holds implemented API calls to MX Platform API
class MxApi
  def initialize
    api_client = ::MxPlatformRuby::ApiClient.new
    api_client.default_headers['Accept'] = 'application/vnd.mx.api.v1+json'
    @mx_platform_api = ::MxPlatformRuby::MxPlatformApi.new(api_client)
  end

  def client
    @mx_platform_api
  end

  # Mx Platform API: POST /users
  # @return UserResponseBody
  def create_user(metadata, email = nil, id = nil, is_disabled: false)
    request_body = ::MxPlatformRuby::UserCreateRequestBody.new(
      user: ::MxPlatformRuby::UserCreateRequest.new(
        email:,
        id:,
        is_disabled:,
        metadata:
      )
    )

    @mx_platform_api.create_user(request_body)
  end

  # Mx Platform API: GET /users/{user_guid}
  # @return UserResponseBody
  def read_user(user_guid)
    @mx_platform_api.read_user(user_guid)
  end

  # List users
  # Mx Platform API: GET /users
  # @return Array<User>
  def fetch_users
    opts = {
      page: 1,
      records_per_page: 100
    }

    users = []
    api_users = @mx_platform_api.list_users(opts)
    api_users.users.each do |user|
      users.push(
        MxHelper::UserAdapter.api_to_user_model(user)
      )
    end

    users
  end

  # Delete an MX user
  # Mx Platform API: DELETE /users/{user_guid}
  # @return nil
  def delete_user(user_guid)
    @mx_platform_api.delete_user(user_guid)
  rescue ::MxPlatformRuby::ApiError => e
    puts "Error when calling MxPlatformApi->delete_user: #{e}"
    raise StandardError, 'Error when calling MxPlatformApi->delete_user'
  end

  # Request a Connect widget URL
  # Mx Platform API: POST /users/{user_guid}/widget_urls
  # @param user_guid: string
  # @param config: Hash of options to add to the request
  # @return widget_url portion of mx response
  def request_connect_widget_url(user_guid, config)
    opts = {
      accept_language: 'en-US'
    }
    request_body = ::MxPlatformRuby::WidgetRequestBody.new(
      widget_url: ::MxPlatformRuby::WidgetRequest.new(
        **config,
        widget_type: 'connect_widget',
        wait_for_full_aggregation: true,
        ui_message_version: 4
      )
    )

    response = @mx_platform_api.request_widget_url(user_guid, request_body, opts)
    response.widget_url
  end

  # Request a Connect widget with the given parameters for Aggregation
  # Mx Platform API: POST /users/{user_guid}/widget_urls
  # @return widget_url portion of mx response
  def request_connect_widget_aggregation(user_guid)
    request_connect_widget_url(user_guid, { mode: 'aggregation' })
  end

  # Request a Connect widget with the given parameters for Verification
  # Mx Platform API: POST /users/{user_guid}/widget_urls
  # @return widget_url portion of mx response
  def request_connect_widget_verification(user_guid)
    request_connect_widget_url(user_guid, { mode: 'verification' })
  end

  # Request all accounts for a user
  # Mx Platform API: GET /users/{user_guid}/accounts
  # @return AccountsResponseBody
  def list_user_accounts(user_guid)
    opts = {
      page: 1,
      records_per_page: 100
    }

    @mx_platform_api.list_user_accounts(user_guid, opts)
  end

  # Lists all the members a user owns
  # Mx Platform API: GET /users/{user_guid}/members
  # @return MembersResponseBody
  def list_members(user_guid)
    opts = {
      page: 1,
      records_per_page: 100
    }

    @mx_platform_api.list_members(user_guid, opts)
  end

  # TODO: consider moving this to a controller instead, general refactor
  # Request all verified accounts for a user
  # Mx Platform API: GET /users/{user_guid}/members
  # Mx Platform API: GET /users/{user_guid}/accounts
  # Mx Platform API: GET /users/{user_guid}/members/{member_guid}/account_numbers
  # @return Hash<{
  #  verified_account_numbers: AccountNumbersResponseBody,
  #  accounts: AccountsResponseBody
  # }>
  def request_verified_accounts(user_guid)
    members_response = list_members(user_guid)
    accounts_response = list_user_accounts(user_guid)

    # To retreive verified accounts you need a member_guid,
    # and we need to call it for each member we've connected to get all accounts
    verified_account_numbers = []

    members_response.members.each do |member|
      # Looped http call
      member_accounts = @mx_platform_api.list_account_numbers_by_member(member.guid, user_guid)
      member_accounts.account_numbers.each do |member_account|
        verified_account_numbers.push member_account
      end
    end

    {
      verified_account_numbers:,
      accounts: accounts_response
    }
  end

  # Mx Platform API: POST /payment_processor_authorization_code
  # @return PaymentProcessorAuthorizationCodeResponseBody
  def request_payment_processor_authorization_code(account_guid, member_guid, user_guid)
    request_body = ::MxPlatformRuby::PaymentProcessorAuthorizationCodeRequestBody.new(
      payment_processor_authorization_code: {
        account_guid:,
        member_guid:,
        user_guid:
      }
    )

    @mx_platform_api.request_payment_processor_authorization_code(request_body, {})
  end
end
