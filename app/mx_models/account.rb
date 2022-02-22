class Account
    attr_accessor :name
    attr_accessor :guid
    attr_accessor :member_guid
    attr_accessor :user_guid

    def initialize(account_values_hash = {})
        name, guid, member_guid, user_guid = account_values_hash.values_at(:name, :guid, :member_guid, :user_guid)
        @name = name
        @guid = guid
        @member_guid = member_guid
        @user_guid = user_guid
    end
end