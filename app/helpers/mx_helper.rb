# frozen_string_literal: true

module MxHelper
  # Used to adapt user inputs to app-friendly models
  class UserAdapter
    # @param api_user [::MxPlatformRuby::UserResponse]
    # @return [User]
    def self.api_to_user_model(api_user)
      # See if user name was passed in
      name = ""
      begin
        metadata = JSON.parse api_user.metadata
        name = metadata.key?("name") ? metadata["name"] : ""
      rescue StandardError => e
        Rails.logger.errors e
      end

      User.new(name: name, email: api_user.email, guid: api_user.guid)
    end
  end
end
