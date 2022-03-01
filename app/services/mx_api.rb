# frozen_string_literal: true

=begin
MX provides many features through the Platform API, documented at https://docs.mx.com.

This file (mx_api.rb) houses the implementations of a few of those endpoints using an
open source gem built with the MX OpenAPI
see: https://github.com/mxenabled/mx-platform-ruby and https://github.com/mxenabled/openapi

For this app, there is also an initializer that configures the authentication for each call
see: config/initializers/mx_api_config.rb
=end

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

    begin
      @mx_platform_api.create_user(request_body)
    rescue ::MxPlatformRuby::ApiError => e
      puts "Error when calling MxPlatformApi->create_user: #{e}"
    end
  end

  # Mx Platform API: GET /users/{user_guid}
  # @return User
  def read_user(user_guid)
    response = @mx_platform_api.read_user(user_guid)
    p response
    # Adapt to the application's expected model
    MxHelper::UserAdapter.api_to_user_model(response.user)
  rescue ::MxPlatformRuby::ApiError => e
    puts "Error when calling MxPlatformApi->read_user: #{e}"
  end

  # List users
  # Mx Platform API: GET /users
  # @return Array<User>
  def fetch_users
    opts = {
      page: 1,
      records_per_page: 100
    }

    begin
      api_users = @mx_platform_api.list_users(opts)
      users = []
      api_users.users.each do |user|
        users.push(
          MxHelper::UserAdapter.api_to_user_model(user)
        )
      end
      users
    rescue ::MxPlatformRuby::ApiError => e
      puts "Error when calling MxPlatformApi->list_users: #{e}"
    end
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
  # @param config: Hash of options to add to the request
  # @return url string
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

    begin
      response = @mx_platform_api.request_widget_url(user_guid, request_body, opts)
      response.widget_url.url
    rescue ::MxPlatformRuby::ApiError => e
      puts "Error when calling MxPlatformApi->request_widget_url: #{e}"
    end
  end

  # Request a Connect widget with the given parameters for Aggregation
  # Mx Platform API: POST /users/{user_guid}/widget_urls
  # @return url string
  def request_connect_widget_aggregation(user_guid)
    request_connect_widget_url(user_guid, { mode: 'aggregation' })
  end
  
  # Request a Connect widget with the given parameters for Verification
  # Mx Platform API: POST /users/{user_guid}/widget_urls
  # @return url string
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

    begin
      @mx_platform_api.list_user_accounts(user_guid, opts)
    rescue ::MxPlatformRuby::ApiError => e
      puts "Error when calling MxPlatformApi->list_user_accounts: #{e}"
      raise StandardError, 'Error when calling MxPlatformApi->list_user_accounts'
    end
  end

  # Lists all the members a user owns
  # Mx Platform API: GET /users/{user_guid}/members
  # @return MembersResponseBody
  def list_members(user_guid)
    opts = {
      page: 1,
      records_per_page: 100
    }

    begin
      @mx_platform_api.list_members(user_guid, opts)
    rescue StandardError
      puts 'Error, could not list members from MX API'
      raise StandardError, 'Could not list members'
    end
  end

  # TODO: consider moving this to a controller instead, general refactor
  # Request all verified accounts for a user
  # Mx Platform API: GET /users/{user_guid}/members
  # Mx Platform API: GET /users/{user_guid}/accounts
  # Mx Platform API: GET /users/{user_guid}/members/{member_guid}/account_numbers
  # @return Account
  def request_verified_accounts(user_guid)
    members_response = list_members(user_guid)
    accounts_response = list_user_accounts(user_guid)

    # To retreive verified accounts you need a member_guid, 
    # and we need to call it for each member we've connected to get all accounts
    verified_account_numbers = []
    begin
      members_response.members.each do |member|
        # Looped http call
        member_accounts = @mx_platform_api.list_account_numbers_by_member(member.guid, user_guid)
        member_accounts.account_numbers.each do |member_account|
          verified_account_numbers.push member_account
        end
      end
    rescue ::MxPlatformRuby::ApiError => e
      puts "Error combining account information: #{e}"
      raise StandardError, 'Combining accounts and account_numbers failed'
    end

    # Match Account Numbers to a the Account to get the Name
    verified_account_numbers.map do |account_number|
      account = accounts_response.accounts.detect { |acct| acct.guid == account_number.account_guid }
      {
        name: account.name,
        guid: account.guid,
        member_guid: account.member_guid,
        user_guid: account.user_guid
      }
    end
  end

  # This works, but is outside of the gem.
  # Mx Platform API: POST /payment_processor_authorization_code
  # @return PaymentProcessorAuthorizationCodeResponseBody
  def request_payment_processor_authorization_code(account_guid, member_guid, user_guid)
    # TODO: This is an issue, we're hard coding to the current dev server.  Fragile
    # FRAGILE!!!
    uri = URI.parse('https://int-api.mx.com/payment_processor_authorization_code')

    header = {
      'Content-Type': 'application/json',
      'Accept': 'application/vnd.mx.api.v1+json'
    }

    request_body = {
      payment_processor_authorization_code: {
        account_guid:,
        member_guid:,
        user_guid:
      }
    }

    # Create the HTTP objects
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = request_body.to_json
    request.basic_auth ENV['MX_CLIENT_ID'], ENV['MX_API_KEY']

    # Send the request
    response = http.request(request)
    response.body
  end
end
