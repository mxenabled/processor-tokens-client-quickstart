# frozen_string_literal: true

class MxApi
  def initialize
    api_client = ::MxPlatformRuby::ApiClient.new
    api_client.default_headers['Accept'] = 'application/vnd.mx.api.v1+json'
    @mx_platform_api = ::MxPlatformRuby::MxPlatformApi.new(api_client)
  end

  def client
    @mx_platform_api
  end

  # Should return the guid on success
  def create_user(metadata, email = nil, id = nil, is_disabled = false)
    request_body = ::MxPlatformRuby::UserCreateRequestBody.new(
      user: ::MxPlatformRuby::UserCreateRequest.new(
        email:,
        id:,
        is_disabled:,
        metadata:
      )
    )

    begin
      response = @mx_platform_api.create_user(request_body)
    rescue ::MxPlatformRuby::ApiError => e
      puts "Error when calling MxPlatformApi->create_user: #{e}"
    end
  end

  # Should return the User model
  def get_user(user_guid)
    response = @mx_platform_api.read_user(user_guid)
    p response
    # adapt to the applications expected model
    MxHelper::UserAdapter.apiUserToModel(response.user)
  rescue ::MxPlatformRuby::ApiError => e
    puts "Error when calling MxPlatformApi->read_user: #{e}"
  end

  # List users you've created with the MX API
  # Should return a list of User models
  def get_users
    opts = {
      page: 1,
      records_per_page: 100
    }

    begin
      api_users = @mx_platform_api.list_users(opts)
      p api_users

      users = []
      api_users.users.each do |user|
        users.push(
          MxHelper::UserAdapter.apiUserToModel(user)
        )
      end
      users
    rescue ::MxPlatformRuby::ApiError => e
      puts "Error when calling MxPlatformApi->list_users: #{e}"
    end
  end

  # Delete an MX user
  def delete_user(user_guid)
    @mx_platform_api.delete_user(user_guid)
  rescue ::MxPlatformRuby::ApiError => e
    puts "Error when calling MxPlatformApi->delete_user: #{e}"
    raise StandardError, 'Error when calling MxPlatformApi->delete_user'
  end

  # Request a Connect widget URL
  # config: ConnectWidgetRequest which contains the widget options
  def request_connect_widget_url(user_guid, config)
    connect_widget_request_body = ::MxPlatformRuby::ConnectWidgetRequestBody.new(
      config:
    )

    begin
      response = @mx_platform_api.request_connect_widget_url(user_guid, connect_widget_request_body)
      puts "\n====== Begin Connect URL ========"
      puts response.user.connect_widget_url
      puts "====== End Connect URL ========\n\n"

      response.user.connect_widget_url
    rescue ::MxPlatformRuby::ApiError => e
      puts "Error when calling MxPlatformApi->request_connect_widget_url: #{e}"
    end
  end

  # Request a Connect widget with the given parameters for Aggregation
  def request_connect_widget_aggregation(user_guid)
    config = ::MxPlatformRuby::ConnectWidgetRequest.new(
      mode: 'aggregation',
      wait_for_full_aggregation: true
    )

    request_connect_widget_url(user_guid, config)
  end

  # Request a Connect widget with the given parameters for Verification
  def request_connect_widget_verification(user_guid)
    config = ::MxPlatformRuby::ConnectWidgetRequest.new(
      mode: 'verification'
    )

    request_connect_widget_url(user_guid, config)
  end

  # Request all accounts for a user
  def request_accounts(user_guid)
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

  # Generate an authorization code for the specified account
  # TODO: This is currently NOT working, parameters are missing when called
  def generate_auth_code_mx_hack_version(account_guid, member_guid, user_guid)
    local_var_path = '/payment_processor_authorization_code'

    # HTTP header 'Content-Type'
    header_params = {
      'Content-Type': 'application/json',
      'Accept': 'application/vnd.mx.api.v1+json'
    }
    # content_type = @mx_platform_api.api_client.select_header_content_type(['application/json'])
    # if !content_type.nil?
    #     header_params['Content-Type'] = content_type
    # end

    body_values = {
      payment_processor_authorization_code: {
        user_guid:,
        member_guid:,
        account_guid:
      }
    }

    options = {
      header_params:,
      body: @mx_platform_api.api_client.object_to_http_body(body_values)
    }
    data, status_code, headers = @mx_platform_api.api_client.call_api(:POST, local_var_path, options)
    puts 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
    puts 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
    puts data
    puts status_code
    puts headers
    puts 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
    puts 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
  end

  # This works, but is outside of the gem.
  def generate_auth_code(account_guid, member_guid, user_guid)
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
