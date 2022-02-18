# Note - not a rails model, just a custom class

class User
    attr_accessor :name
    attr_accessor :email
    attr_accessor :guid

    def initialize(user_values_hash = {})
        name, email, guid = user_values_hash.values_at(:name, :email, :guid)
        @name = name
        @email = email
        @guid = guid
    end

    # Returns the guid
    def create_external_user()
        mx_platform_api = ::MxApi.new

        metadata_hash = {name: @name}
        response = mx_platform_api.create_user(metadata_hash.to_json, @email)

        unless response.user.guid
            puts "Error: creation of MX user failed"
        end

        response.user.guid
    end

    # Get a single user from the api
    def self.get_user(user_guid)
        mx_platform_api = ::MxApi.new

        response = mx_platform_api.get_user(user_guid)

        unless response
            puts "Could not find user"
        end

        response
    end
end
