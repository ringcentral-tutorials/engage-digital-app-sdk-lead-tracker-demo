class SessionsController < ApplicationController
  skip_before_action :authenticate!
  skip_before_action :verify_authenticity_token

  delegate :ed_domain_name, :ed_hostname, :ed_app_sdk_client_id, :ed_app_sdk_client_secret, to: LeadTracker::Application

  # POST /session/callback
  def callback
    if params[:error].present?
      render(text: params[:error], content_type: 'text/plain')
    else
      token = client.auth_code.get_token(params[:code], redirect_uri: callback_session_url(origin: params[:origin]))
      response = token.get("https://#{ed_domain_name}.api.#{ed_hostname}/1.0/users/me")
      json = ActiveSupport::JSON.decode(response.body)
      session[:current_user_id] = json['id']
      session[:current_user_email] = json['email']

      redirect_to(params[:origin].presence || root_url)
    end
  end

  # GET /session/logout
  def logout
    session[:current_user_id] = nil
    session[:current_user_email] = nil
    render(text: 'Logged out', content_type: 'text/plain')
  end

  # GET /session/new
  def new
    session[:current_user_id] = nil
    session[:current_user_email] = nil
    redirect_to(client.auth_code.authorize_url(redirect_uri: callback_session_url(origin: params[:origin])))
  end

  private

  def client
    @client ||= OAuth2::Client.new(ed_app_sdk_client_id, ed_app_sdk_client_secret, site: "https://#{ed_domain_name}.#{ed_hostname}")
  end
end
