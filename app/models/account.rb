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

  # Returns a list of Account models for user_guid
  # This returns all user's accounts
  # Can raise an ::MxPlatformRuby::ApiError
  def self.get_accounts(user_guid)
    mx_platform_api = ::MxApi.new
    mx_response = mx_platform_api.list_user_accounts(user_guid)

    mx_response.accounts.map do |account|
      Account.new(
        {
          name: account.name,
          guid: account.guid,
          member_guid: account.member_guid,
          user_guid: account.user_guid
        }
      )
    end
  end

  # Returns a list of Account models for user_guid
  # These accounts are considered as "verified"
  # Can raise an ::MxPlatformRuby::ApiError
  def self.get_verified_accounts(user_guid)
    mx_platform_api = ::MxApi.new
    mx_data = mx_platform_api.request_verified_accounts(user_guid)

    mx_data[:verified_account_numbers].map do |account_number|
      account = mx_data[:accounts].accounts.detect do |acct|
        acct.guid == account_number.account_guid
      end

      Account.new(
        {
          name: account.name,
          guid: account.guid,
          member_guid: account.member_guid,
          user_guid: account.user_guid
        }
      )
    end
  end
end
