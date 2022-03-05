# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def render_404
    render :file => "#{Rails.root}/public/404.html",  
      layout: false, 
      status: :not_found
  end

  # @param mx_response should be data to return, or an ApiError
  def build_response mx_response
    if mx_response.is_a? ::MxPlatformRuby::ApiError
      ::ApiResponseHelper::Build.error_response(mx_response)
    else
      ::ApiResponseHelper::Build.success_response(mx_response)
    end
  end
end
