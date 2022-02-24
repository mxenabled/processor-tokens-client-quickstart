module MxHelper
    class UserAdapter
        # @param api_user [::MxPlatformRuby::UserResponse]
        # @return [User]
        def self.apiUserToModel api_user
            # See if user name was passed in
            name = ""
            begin
              metadata = JSON.parse api_user.metadata
              name = metadata.key?('name') ? metadata["name"] : ""
            rescue
              puts "Bad metadata"
            end

            User.new({
                name: name,
                email: api_user.email,
                guid: api_user.guid
            })
        end
    end
end
