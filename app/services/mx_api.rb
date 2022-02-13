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

    def request_connect_widget_aggregation(user_guid)
        # {:mode => "aggregation"} >>> unsupported
        connect_widget_request_body = ::MxPlatformRuby::ConnectWidgetRequestBody.new()

        begin
            response = @mx_platform_api.request_connect_widget_url(user_guid, connect_widget_request_body)
            puts "====== Begin Connect URL ========"
            puts response.user.connect_widget_url
            puts "====== End Connect URL ========"
            response
        rescue ::MxPlatformRuby::ApiError => e
            puts "Error when calling MxPlatformApi->request_connect_widget_url: #{e}"
        end
    end
end