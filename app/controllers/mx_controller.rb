class MxController < ApplicationController
    # Get the MX Connect widget URL
    # Return the HTML from mx
    def aggregation
        mx_platform_api = ::MxApi.new
        response = mx_platform_api.request_connect_widget_aggregation(params[:user_guid])
        @widget_url = response.user.connect_widget_url
        
        unless response
            puts "Error: creation of Connect URL failed"
        end
    end
end
