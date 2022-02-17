class MxController < ApplicationController
    # Get the MX Connect widget URL
    # Return the HTML from mx
    def aggregation
        mx_platform_api = ::MxApi.new
        @widget_url = mx_platform_api.request_connect_widget_aggregation(params[:user_guid])
        
        unless response
            puts "Error: creation of Connect Aggregation URL failed"
        end

        render json: {
            url: @widget_url
        }
    end

    def verification
        mx_platform_api = ::MxApi.new
        @widget_url = mx_platform_api.request_connect_widget_verification(params[:user_guid])
        
        unless response
            puts "Error: creation of Connect Verification URL failed"
        end

        render json: {
            url: @widget_url
        }
    end

    def accounts
        mx_platform_api = ::MxApi.new
        api_accounts = mx_platform_api.request_accounts(params[:user_guid])

        @accounts = []
        api_accounts.accounts.each do |account|
            @accounts.push({
                name: account.name,
            })
        end
    end
end
