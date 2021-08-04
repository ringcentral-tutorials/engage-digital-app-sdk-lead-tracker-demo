class ApplicationMailer < ActionMailer::Base
  default from: "#{ENV.fetch('MAILGUN_FROM', 'from')}@#{ENV['MAILGUN_DOMAIN']}"
  layout 'mailer'
end
