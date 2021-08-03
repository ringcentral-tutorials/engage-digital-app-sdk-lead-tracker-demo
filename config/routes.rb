Rails.application.routes.draw do
  match 'leads/:identity_group_id', to: 'leads#show', via: %i(get)
  match 'leads',                    to: 'leads#save', via: %i(post patch)

  resource 'session', only: %w(new) do
    collection do
      get 'callback'
      get 'logout'
    end
  end
end
