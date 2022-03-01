# frozen_string_literal: true

# Used for forwarding front end calls to MX
class MxController < ApplicationController
  # Get the MX Connect widget URL
  # Return the HTML from mx
  def aggregation
    mx_platform_api = ::MxApi.new
    @widget_url = mx_platform_api.request_connect_widget_aggregation(params[:user_guid])

    puts 'Error: creation of Connect Aggregation URL failed' unless @widget_url

    render json: {
      url: @widget_url
    }
  end

  def verification
    mx_platform_api = ::MxApi.new
    @widget_url = mx_platform_api.request_connect_widget_verification(params[:user_guid])

    puts 'Error: creation of Connect Verification URL failed' unless @widget_url

    render json: {
      url: @widget_url
    }
  end

  def accounts
    mx_platform_api = ::MxApi.new
    api_accounts = mx_platform_api.list_user_accounts(params[:user_guid])

    @accounts = []
    api_accounts.accounts.each do |account|
      @accounts.push(
        Account.new({
                      name: account.name,
                      guid: account.guid,
                      member_guid: account.member_guid,
                      user_guid: account.user_guid
                    })
      )
    end

    render partial: 'accounts', locals: { accounts: @accounts }
  end

  def verified_accounts
    mx_platform_api = ::MxApi.new
    api_accounts = mx_platform_api.request_verified_accounts(params[:user_guid])

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

    render partial: 'verified_accounts', locals: { accounts: @accounts }
  end

  def generate_auth_code
    mx_platform_api = ::MxApi.new
    response_body = mx_platform_api.request_payment_processor_authorization_code(
      params[:account_guid],
      params[:member_guid],
      params[:user_guid]
    )
    authorization_code = response_body.payment_processor_authorization_code.authorization_code

    render json: {
      authorization_code:
    }
  end
end
