class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate
    request_http_basic_authentication unless authenticate_with_http_basic { |u, p| u == "cpt" && p = "cup" }
  end
end
