# frozen_string_literal: true

require 'spec_helper'

describe ::ApiResponseHelper::Builder do
  describe '.success_response' do
    let(:data) { OpenStruct.new(status: 'error', code: nil, response: nil, error_details: nil) }

    let(:response_message) { described_class.success_response(data) }

    it { expect(response_message.status).to eq 'success' }
    it { expect(response_message.response).to eq data }
    it { expect(response_message).to be_an_instance_of(::ApiResponseHelper::Response) }
  end

  describe '.error_response' do
    let(:error) do
      ::MxPlatformRuby::ApiError.new(code: 500, response_headers: {}, response_body: 'Bad things happened')
    end
    let(:error_message) do
      # msg =
      <<~ERROR.chomp
        Error message: the server returns an error
        HTTP status code: 500
        Response headers: {}
        Response body: Bad things happened
      ERROR
    end

    let(:response_message) { described_class.error_response(error) }

    it { expect(response_message.status).to eq 'error' }
    it { expect(response_message.response).to eq error.response_body }
    it { expect(response_message.error_details).to eq error_message }
    it { expect(response_message).to be_an_instance_of(::ApiResponseHelper::Response) }
  end
end
