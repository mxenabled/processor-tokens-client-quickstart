# frozen_string_literal: true

require 'test_helper'
require 'mx-platform-ruby'

class ApiResponseHelperTest < ActiveSupport::TestCase
  test 'error messages are built for the UI' do
    error = ::MxPlatformRuby::ApiError.new(
      code: 500,
      response_headers: {},
      response_body: 'Bad things happened'
    )

    message = ::ApiResponseHelper::Builder.error_response(error)

    assert_equal message.status, 'error', 'UI message has status'
    assert_equal message.code, 500, 'UI message has code'
    assert_equal message.response, 'Bad things happened', 'UI message has response'
    # error messages have a lot of data to parse if you want
    assert message.error_details, 'UI message has error with message'
  end

  test 'success messages are built for the UI' do
    api_response = {
      test: [
        1, 2, 3
      ]
    }
    message = ::ApiResponseHelper::Builder.success_response(api_response)

    assert_equal message.status, 'success', 'UI message has status'
    assert_equal message.response, api_response, 'UI message has exact response'
    assert_nil message.error_details, 'UI message has no error'
  end
end
