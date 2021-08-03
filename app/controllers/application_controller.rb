class ApplicationController < ActionController::Base
  before_action :allow_iframe
  protect_from_forgery with: :exception
  before_action :authenticate!

  private

  def allow_iframe
    response.headers.except!('X-Frame-Options')
  end

  def authenticate!
    redirect_to(new_session_url(origin: request.url)) if session[:current_user_id].blank?
  end
end
