# frozen_string_literal: true

require 'spec_helper'
require 'ostruct'


describe ::Account, type: :model do
  let(:mx_api) { double("MxApi") }
  let(:user_guid) { "USR-123" }

  before { allow(::MxApi).to receive(:new).and_return(mx_api) }
  before { allow(::Account).to receive(:new) }

  describe ".get_accounts" do
    let(:mx_response) do
      OpenStruct.new(
        accounts: [
          OpenStruct.new(name: 'Account 1', guid: 'ACT-123', member_guid: 'MBR-123', user_guid: user_guid),
          OpenStruct.new(name: 'Account 2', guid: 'ACT-456', member_guid: 'MBR-456', user_guid: user_guid)
        ]
      )
    end

    context "when a user has accounts" do
      before { allow(mx_api).to receive(:list_user_accounts).and_return(mx_response) }

      it "returns a list of accounts" do
        described_class.get_accounts(user_guid)
        expect(::Account).to have_received(:new).twice
      end
    end

    context "when a user has no accounts" do
      let(:user_guid) { "USR-123" }

      before { allow(mx_api).to receive(:list_user_accounts).and_return(OpenStruct.new(accounts: [])) }

      it "returns a list of accounts" do
        described_class.get_accounts(user_guid)
        expect(::Account).to have_received(:new).exactly(0).times
      end
    end
  end

  describe ".get_verified_accounts" do

    before { allow(mx_api).to receive(:request_verified_accounts).and_return(mx_response) }

    context "when a user has accounts" do
      let(:user_guid) { "USR-123" }

      let(:mx_response) do
        {
          verified_account_numbers: [
            OpenStruct.new(name: 'Account 1', account_guid: 'ACT-123', member_guid: 'MBR-123', user_guid: user_guid),
            OpenStruct.new(name: 'Account 2', account_guid: 'ACT-012', member_guid: 'MBR-456', user_guid: user_guid)
          ],
          accounts: OpenStruct.new(
            accounts: [
              OpenStruct.new(name: 'Account 1', guid: 'ACT-123', member_guid: 'MBR-123', user_guid: user_guid),
              OpenStruct.new(name: 'Account 2', guid: 'ACT-012', member_guid: 'MBR-456', user_guid: user_guid)
            ]
          )
        }
      end

      it "returns a list of accounts" do
        described_class.get_verified_accounts(user_guid)
        expect(::Account).to have_received(:new).twice
      end
    end

    context "when a user has no accounts" do
      let(:mx_response) do
        {
          verified_account_numbers: [],
          accounts: []
        }
      end

      it "returns a list of accounts" do
        described_class.get_verified_accounts(user_guid)
        expect(::Account).to have_received(:new).exactly(0).times
      end
    end
  end
end
