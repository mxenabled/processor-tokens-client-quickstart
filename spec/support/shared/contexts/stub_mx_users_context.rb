# frozen_string_literal: true

shared_context "stub MX users" do
  let(:api) { double }
  let(:new_user_params) {
    {:name => "Wolverine", :email => "xman@mx.com"}
  }
  let(:params) { {:id => "USR-123"} }
  let(:response) { OpenStruct.new(:user => user) }
  let(:user) {
    User.new(:email => "man@mx.com", :guid => "USR-123", :name => "Spider")
  }
  let(:users) { [user] }

  before do
    allow(::MxApi).to receive(:new) { api }
    allow(api).to receive(:create_user) { response }
    allow(api).to receive(:delete_user) { response }
    allow(api).to receive(:fetch_users) { users }
    allow(api).to receive(:read_user) { response }
  end
end
