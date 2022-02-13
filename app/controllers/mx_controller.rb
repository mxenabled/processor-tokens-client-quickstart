class MxController < ApplicationController
    # Get the MX Connect widget URL
    # Return the HTML from mx
    def aggregation
        mx_platform_api = ::MxApi.new
        response = mx_platform_api.request_connect_widget_aggregation(params[:user_guid])
        @widget_url = response.user.connect_widget_url
        
        unless response
            puts "Error: creation of Connect Aggregation URL failed"
        end
    end

    def verification
        mx_platform_api = ::MxApi.new
        @widget_url = mx_platform_api.request_connect_widget_verification(params[:user_guid])
        
        unless response
            puts "Error: creation of Connect Verification URL failed"
        end

        render "aggregation"
    end
end
