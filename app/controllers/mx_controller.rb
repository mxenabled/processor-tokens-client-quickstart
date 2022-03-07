# frozen_string_literal: true

# Used for forwarding front end calls to MX:
# All of the controller actions return an ApiResponse object
# see: app/helpers/api_response_helper.rb
class MxController < ApplicationController
  # Get the MX Connect widget URL
  # Return the HTML from mx
  def aggregation
    mx_platform_api = ::MxApi.new
    url_response = mx_platform_api.request_connect_widget_aggregation(params[:user_guid])
    render json: success_response(url_response)
  rescue ::MxPlatformRuby::ApiError => e
    render json: mx_error_response(e)
  end

  def verification
    mx_platform_api = ::MxApi.new
    url_response = mx_platform_api.request_connect_widget_verification(params[:user_guid])
    render json: success_response(url_response)
  rescue ::MxPlatformRuby::ApiError => e
    render json: mx_error_response(e)
  end

  def accounts
    mx_platform_api = ::MxApi.new
    mx_response = mx_platform_api.list_user_accounts(params[:user_guid])

    # UI variables
    @accounts = []

    mx_response.accounts.each do |account|
      @accounts.push(
        Account.new(
          {
            name: account.name,
            guid: account.guid,
            member_guid: account.member_guid,
            user_guid: account.user_guid
          }
        )
      )
    end

    render json: success_response(
      {
        html: (render_to_string partial: 'accounts', locals: { accounts: @accounts })
      }
    )
  rescue ::MxPlatformRuby::ApiError => e
    render json: mx_error_response(e)
  end

  def verified_accounts
    mx_platform_api = ::MxApi.new
    verified_accounts = mx_platform_api.request_verified_accounts(params[:user_guid])

    @accounts = []
    verified_accounts.each do |account|
      @accounts.push(
        Account.new(
          {
            name: account[:name],
            guid: account[:guid],
            member_guid: account[:member_guid],
            user_guid: account[:user_guid]
          }
        )
      )
    end

    render json: success_response(
      {
        html: (render_to_string partial: 'verified_accounts', locals:
          { accounts: @accounts })
      }
    )
  rescue ::MxPlatformRuby::ApiError => e
    render json: mx_error_response(e)
  end

  def generate_auth_code
    mx_platform_api = ::MxApi.new

    api_response = mx_platform_api.request_payment_processor_authorization_code(
      params[:account_guid],
      params[:member_guid],
      params[:user_guid]
    )

    render json: success_response(api_response)
  rescue ::MxPlatformRuby::ApiError => e
    render json: mx_error_response(e)
  end
end
