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

    def request_connect_widget_verification(user_guid)
        uri = URI.parse("https://int-api.mx.com/users/#{user_guid}/widget_urls")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        post_req = Net::HTTP::Post.new(uri.request_uri)
        post_req["Accept"] = "application/vnd.mx.api.v1+json"
        post_req.content_type = "application/json"
        post_req.basic_auth ENV['MX_CLIENT_ID'], ENV['MX_API_KEY']
        post_req.body = '{
            "widget_url": {
                "widget_type": "connect_widget", 
                "mode": "verification"
            }
        }'
        res = http.request(post_req)
        
        mx_response = JSON.parse res.body
        url = mx_response["widget_url"]["url"]

        puts "\n====== Begin Connect Verification URL ========"
        puts "url: #{url}"
        puts "====== End Connect Verification URL ========\n\n"

        case res
        when Net::HTTPSuccess, Net::HTTPRedirection
            # OK
            url
        else
            res.value
        end
    end
end