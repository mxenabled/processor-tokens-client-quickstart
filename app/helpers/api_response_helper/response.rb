module ApiResponseHelper
  # Standard structure for Api responses
  class Response
    attr_accessor :status, :code, :response, :error_details

    def success
      status == 'success'
    end

    def to_hash
      {
        status:,
        code:,
        response:,
        error_details:
      }
    end
  end
end
