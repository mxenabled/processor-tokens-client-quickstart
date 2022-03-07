require 'rails_helper'

RSpec.describe ::MxHelper, type: :helper do
  subject { ::MxHelper::UserAdapter.api_to_user_model(api_user) }

  let(:metadata) { '' }
  let(:api_user) do
    ::MxPlatformRuby::UserResponse.new(
      :email => 'testemail',
      :metadata => metadata,
      :guid => 'testguid'
    )
  end

  describe ".api_to_user_model" do
    context "when metadata contains a name" do
      let(:metadata) { '{"name":"testname"}' }

      it { expect(subject.name).to eq 'testname' }
      it { expect(subject.email).to eq 'testemail' }
      it { expect(subject.guid).to eq 'testguid' }
    end

    context "when metadata does not contain a name" do
      let(:metadata) { '{}' }

      it { expect(subject.name).to be_blank }
    end

    context  "when metadata is not json" do
      let(:metadata) { 'badjson' }

      it { expect(subject.name).to be_blank }
    end
  end
end
