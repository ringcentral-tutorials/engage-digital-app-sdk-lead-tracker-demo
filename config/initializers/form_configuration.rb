Rails.application.configure do
  config.form_configuration = ActiveSupport::ConfigurationFile.parse("#{Rails.root}/config/form_configuration.yml").deep_symbolize_keys
end
