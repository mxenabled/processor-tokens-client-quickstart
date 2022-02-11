class User < ApplicationRecord
    validates :name, presence: true, length: {minimum: 3}
    validates :password, presence: true, length: {minimum: 10}

    def generate_external_id
        mx_platform_api = ::MxApi.new
        mx_platform_api.create_user("Create a test user!")
    end
end
