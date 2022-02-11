class User < ApplicationRecord
    validates :name, presence: true, length: {minimum: 3}
    validates :password, presence: true, length: {minimum: 10}

    def generate_external_id
        api_client = ::MxPlatformRuby::ApiClient.new
        api_client.default_headers['Accept'] = 'application/vnd.mx.api.v1+json'
        mx_platform_api = ::MxPlatformRuby::MxPlatformApi.new(api_client)

        request_body = ::MxPlatformRuby::UserCreateRequestBody.new(
            user: ::MxPlatformRuby::UserCreateRequest.new(
                metadata: "Create a test user!"
            )
        )

        begin
            response = mx_platform_api.create_user(request_body)
        rescue ::MxPlatformRuby::ApiError => e
            puts "Error when calling MxPlatformApi->create_user: #{e}"
        end
    end
end
