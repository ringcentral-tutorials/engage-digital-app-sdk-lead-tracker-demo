class LeadMailer < ApplicationMailer
  EMPTY_INFO_PLACEHOLDER = 'N/A'.freeze

  def notify_lead_creation(lead)
    return unless lead.agent_email.present? && LeadTracker::Application.mailgun_configured?

    @entity = lead.entity&.humanize || EMPTY_INFO_PLACEHOLDER
    @firstname = lead.firstname.presence || EMPTY_INFO_PLACEHOLDER
    @lastname = lead.lastname.presence || EMPTY_INFO_PLACEHOLDER
    @email = lead.email.presence || EMPTY_INFO_PLACEHOLDER
    @phone_number = lead.phone_number.presence || EMPTY_INFO_PLACEHOLDER
    @question = lead.question.presence || EMPTY_INFO_PLACEHOLDER
    @data = lead.data.transform_keys(&:humanize).transform_values { |v| v.presence || EMPTY_INFO_PLACEHOLDER }
    @lead_type = lead.lead_type&.humanize || EMPTY_INFO_PLACEHOLDER
    @comment_summary = lead.comment_summary.presence || EMPTY_INFO_PLACEHOLDER

    mail(subject: "Lead #{lead.firstname} #{lead.lastname}", to: lead.agent_email)
  end
end
