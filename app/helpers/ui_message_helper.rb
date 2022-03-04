# frozen_string_literal: true

module UiMessageHelper
  class UiMessage
    attr_accessor :status, :code, :response, :error_details
  end

  class MessageBuilder
    # This function builds the message that the UI can consume, specific to success
    # @param response: data from a successful api call
    def build_success_message(api_response)
      message = UiMessage.new
      message.status = 'success'
      message.response = api_response
      message
    end

    # This function builds the message that the UI can consume, specific to errors
    # @param error: MxPlatformRuby::ApiError
    def build_error_message(api_error)
      message = UiMessage.new
      message.status = 'error'
      message.code = api_error.code
      message.response = api_error.response_body
      message.error_details = api_error.message
      message
    end
  end
end
