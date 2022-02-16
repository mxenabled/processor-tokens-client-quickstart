class MxApi
    def initialize
        api_client = ::MxPlatformRuby::ApiClient.new
        api_client.default_headers['Accept'] = 'application/vnd.mx.api.v1+json'
        @mx_platform_api = ::MxPlatformRuby::MxPlatformApi.new(api_client)
    end

    def client
        @mx_platform_api
    end

    def create_user(metadata)
        request_body = ::MxPlatformRuby::UserCreateRequestBody.new(
            user: ::MxPlatformRuby::UserCreateRequest.new(
                metadata: metadata
            )
        )

        begin
            response = @mx_platform_api.create_user(request_body)
        rescue ::MxPlatformRuby::ApiError => e
            puts "Error when calling MxPlatformApi->create_user: #{e}"
        end
    end

    # List users you've created with the MX API
    def get_users
        opts = {
            page: 1,
            records_per_page: 100
        }
        
        begin
            response = @mx_platform_api.list_users(opts)
            p response
        rescue ::MxPlatformRuby::ApiError => e
            puts "Error when calling MxPlatformApi->list_users: #{e}"
        end
    end

    # Delete an MX user
    def delete_user(user_guid)
        begin
            @mx_platform_api.delete_user(user_guid)
        rescue ::MxPlatformRuby::ApiError => e
            puts "Error when calling MxPlatformApi->delete_user: #{e}"
            raise StandardError.new "Error when calling MxPlatformApi->delete_user: #{e}"
        end
    end

    # Request a Connect widget URL
    # config: ConnectWidgetRequest which contains the widget options
    def request_connect_widget_url(user_guid, config)
        connect_widget_request_body = ::MxPlatformRuby::ConnectWidgetRequestBody.new(
            config: config
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
            mode: "aggregation"
        )
        
        request_connect_widget_url(user_guid, config)
    end
    
    # Request a Connect widget with the given parameters for Verification
    def request_connect_widget_verification(user_guid)
        config = ::MxPlatformRuby::ConnectWidgetRequest.new(
            mode: "verification"
        )

        request_connect_widget_url(user_guid, config)
    end
end