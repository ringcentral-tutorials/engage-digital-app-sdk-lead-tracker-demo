class Lead < ApplicationRecord
  attr_accessor :agent_email

  after_create :notify_agent, if: -> { agent_email.present? && LeadTracker::Application.mailgun_configured? }

  private

  def notify_agent
    LeadMailer.notify_lead_creation(self).deliver_now rescue nil
  end
end
