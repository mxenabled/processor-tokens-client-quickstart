# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def render_404
    render file: "#{Rails.root}/public/404.html",
           layout: false,
           status: :not_found
  end

  def success_response(data)
    ::ApiResponseHelper::Build.success_response(data)
  end

  def mx_error_response(error)
    ::ApiResponseHelper::Build.error_response(error)
  end
end
