# frozen_string_literal: true

module ApiResponseHelper
  # Builder is used to "build" either the success or error messages returned from the API
  class Builder
    # This function builds the message that the UI can consume, specific to success
    # @param response: data from a successful api call
    def self.success_response(api_response)
      message = ::ApiResponseHelper::Response.new
      message.status = 'success'
      message.response = api_response
      message
    end

    # This function builds the message that the UI can consume, specific to errors
    # @param error: MxPlatformRuby::ApiError
    def self.error_response(api_error)
      message = ::ApiResponseHelper::Response.new
      message.status = 'error'
      message.code = api_error.code
      message.response = api_error.response_body
      message.error_details = api_error.message
      message
    end
  end
end
