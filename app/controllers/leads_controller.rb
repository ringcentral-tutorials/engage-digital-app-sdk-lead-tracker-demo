class LeadsController < ApplicationController
  before_action :set_lead_fields, only: %i(show)
  before_action :set_identity_group_id
  before_action :set_channel_id
  before_action :fetch_lead

  delegate :ed_domain_name, :ed_hostname, :ed_api_access_token, to: LeadTracker::Application

  # GET /leads/:identity_group_id
  def show
  end

  # POST/PATCH /leads
  def save
    action = @lead.new_record? ? 'created' : 'updated'
    @lead.assign_attributes(lead_params.except(:data))
    @lead.data.merge!(lead_params[:data] || {})
    @lead.agent_email = session[:current_user_email]
    @lead.save

    flash[:notice] = "Lead correctly #{action}"
    redirect_to url_for(controller: :leads, action: :show, identity_group_id: @lead.identity_group_id, params: { channel_id: params.dig(:lead, :channel_id) })
  end

  private

  def fetch_lead
    @lead = Lead.find_or_initialize_by(identity_group_id: @identity_group_id, entity: entity_name)
  end

  def set_identity_group_id
    @identity_group_id = params[:identity_group_id] || params.dig(:lead, :identity_group_id)
  end

  def set_channel_id
    @channel_id = params[:channel_id] || params.dig(:lead, :channel_id)
  end

  def set_lead_fields
    res = faraday.get("/1.0/identity_groups/#{params[:identity_group_id]}")

    @firstname = res.body['firstname']
    @lastname = res.body['lastname']
    @email = res.body.dig('emails', 0)
    @phone_number = res.body.dig('mobile_phones', 0)
    @intervention_id = params[:intervention_id].presence
    @thread_id = params[:thread_id].presence
    @agent_id = session[:current_user_id]
  end

  def faraday
    @faraday ||= Faraday.new(url: "https://#{ed_domain_name}.api.#{ed_hostname}", headers: { 'Authorization': "Bearer #{ed_api_access_token}" }) do |f|
      f.response :json, content_type: /\bjson$/
    end
  end

  def entity_name
    @entity_name ||= Rails.application.config.form_configuration[:entities].keys.find do |name|
      Rails.application.config.form_configuration.dig(:entities, name.to_sym, :channel_ids).include?(@channel_id)
    end || 'N/A'
  end

  def lead_params
    params.require(:lead).permit(:identity_group_id, :entity, :firstname, :lastname, :email, :phone_number, :question, :comment_summary, :lead_type, :intervention_id, :thread_id, :agent_id, data: {})
  end
end
