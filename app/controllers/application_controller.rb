class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  def handle_unvarified_request
    sign_out
    super
  end
end
