class Account
    attr_accessor :name
    attr_accessor :guid

    def initialize(account_values_hash = {})
        name, guid = account_values_hash.values_at(:name, :guid)
        @name = name
        @guid = guid
    end
end