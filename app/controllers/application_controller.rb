class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  def handle_unvarified_request
    sign_out
    super
  end

  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path
      end
    end
end
