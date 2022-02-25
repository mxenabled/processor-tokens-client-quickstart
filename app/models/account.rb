# frozen_string_literal: true

# A simplified Account for this application
class Account
  attr_accessor :name, :guid, :member_guid, :user_guid

  def initialize(account_values_hash = {})
    name, guid, member_guid, user_guid = account_values_hash.values_at(:name, :guid, :member_guid, :user_guid)
    @name = name
    @guid = guid
    @member_guid = member_guid
    @user_guid = user_guid
  end
end
