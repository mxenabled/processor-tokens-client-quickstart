require "spec_helper"

describe ::User do
  include_context "stub MX users"

  subject { user }

  describe ".create_external_user" do
    it "returs user guid" do
      subject.create_external_user

      expect(response.user.guid).to eq("USR-123")
    end
  end

  describe "#get_user" do
    it "returns a user" do
      described_class.get_user("USR-123")

      expect(response.user).to be(user)
    end
  end
end
