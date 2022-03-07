# frozen_string_literal: true

# Used for forwarding front end calls to MX
class MxController < ApplicationController
  # Get the MX Connect widget URL
  # Return the HTML from mx
  def aggregation
    mx_platform_api = ::MxApi.new
    mx_response = mx_platform_api.request_connect_widget_aggregation(params[:user_guid])

    render json: build_response(mx_response)
  end

  def verification
    mx_platform_api = ::MxApi.new
    mx_response = mx_platform_api.request_connect_widget_verification(params[:user_guid])

    render json: build_response(mx_response)
  end

  def accounts
    mx_platform_api = ::MxApi.new
    mx_response = mx_platform_api.list_user_accounts(params[:user_guid])

    # If there was an error return the error response now
    if mx_response.is_a? ::MxPlatformRuby::ApiError
      render json: ::ApiResponseHelper::Build.error_response(mx_response)
      return
    end

    # UI variables
    @accounts = []

    mx_response.accounts.each do |account|
      @accounts.push(
        Account.new({
          name: account.name,
          guid: account.guid,
          member_guid: account.member_guid,
          user_guid: account.user_guid
        })
      )
    end

    render json: build_response({
      html: (render_to_string partial: 'accounts', locals: { accounts: @accounts })
    })
  end

  def verified_accounts
    mx_platform_api = ::MxApi.new
    verified_accounts = mx_platform_api.request_verified_accounts(params[:user_guid])

    # Early return if there was an error response already
    if verified_accounts.is_a? ::MxPlatformRuby::ApiError
      render json: build_response(verified_accounts)
      return
    end

    @accounts = []
    verified_accounts.each do |account|
      @accounts.push(
        Account.new({
          name: account[:name],
          guid: account[:guid],
          member_guid: account[:member_guid],
          user_guid: account[:user_guid]
        })
      )
    end

    render json: build_response({
      html: (render_to_string partial: 'verified_accounts', locals: 
        { accounts: @accounts })
    })
  end

  def generate_auth_code
    mx_platform_api = ::MxApi.new

    api_response = mx_platform_api.request_payment_processor_authorization_code(
      params[:account_guid],
      params[:member_guid],
      params[:user_guid]
    )

    render json: build_response(api_response)
  end
end
