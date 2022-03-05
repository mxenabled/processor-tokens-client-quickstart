# frozen_string_literal: true

# Used for forwarding front end calls to MX
class MxController < ApplicationController
  # Get the MX Connect widget URL
  # Return the HTML from mx
  def aggregation
    mx_platform_api = ::MxApi.new
    api_response = mx_platform_api.request_connect_widget_aggregation(params[:user_guid])

    puts 'Error: creation of Connect Aggregation URL failed' unless api_response

    render json: api_response
  end

  def verification
    mx_platform_api = ::MxApi.new
    api_response = mx_platform_api.request_connect_widget_verification(params[:user_guid])

    puts 'Error: creation of Connect Verification URL failed' unless api_response

    render json: api_response
  end

  def accounts
    mx_platform_api = ::MxApi.new
    api_response = mx_platform_api.list_user_accounts(params[:user_guid])

    # UI variables
    @accounts = []

    if api_response.success
      api_response.response.accounts.each do |account|
        @accounts.push(
          Account.new({
                        name: account.name,
                        guid: account.guid,
                        member_guid: account.member_guid,
                        user_guid: account.user_guid
                      })
        )
      end

      response = {
        html: (render_to_string partial: 'accounts', locals: { accounts: @accounts })
      }
    else
      response = "Error getting accounts from MX"
    end

    render json: {
      status: api_response.status,
      code: api_response.code,
      response:,
      error_details: api_response.error_details
    }
  end

  def verified_accounts
    mx_platform_api = ::MxApi.new
    api_response = mx_platform_api.request_verified_accounts(params[:user_guid])

    # Early return if there was an error response already
    if !api_response.success
      render json: api_response
      return
    end

    api_accounts = api_response.response[:verified_accounts]

    @accounts = []
    api_accounts.each do |account|
      @accounts.push(
        Account.new({
          name: account[:name],
          guid: account[:guid],
          member_guid: account[:member_guid],
          user_guid: account[:user_guid]
        })
      )
    end

    render json: {
      status: api_response.status,
      code: api_response.code,
      response: {
        html: (render_to_string partial: 'verified_accounts', locals: 
          { accounts: @accounts })
      },
      error_details: api_response.error_details
    }
  end

  def generate_auth_code
    mx_platform_api = ::MxApi.new

    api_response = mx_platform_api.request_payment_processor_authorization_code(
      params[:account_guid],
      params[:member_guid],
      params[:user_guid]
    )

    render json: api_response
  end
end
