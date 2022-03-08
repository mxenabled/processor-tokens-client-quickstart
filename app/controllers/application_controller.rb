# frozen_string_literal: true

# The parent class that houses shared controller methods
class ApplicationController < ActionController::Base
  def render404
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
