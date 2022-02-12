class User < ApplicationRecord
    validates :name, presence: true, length: {minimum: 3}
    validates :password, presence: true, length: {minimum: 10}

    # Returns the guid
    def create_external_user
        mx_platform_api = ::MxApi.new
        response = mx_platform_api.create_user("Create a test user!")

        unless response.user.guid
            puts "Error: creation of MX user failed"
        end

        response.user.guid
    end
end
