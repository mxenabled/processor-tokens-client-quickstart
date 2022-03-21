# frozen_string_literal: true

Rails.application.routes.draw do
  # Start at the welcome screen
  # Shows instructions for using the demo
  root 'welcome#index'

  # Create and View your MX Users
  # Views here are rendered with rails
  resources :users

  # These endpoints call the MX Platform API return json responses,
  # each with request statuses and relevant data
  get '/mx/aggregation/:user_guid', to: 'mx#aggregation'
  get '/mx/verification/:user_guid', to: 'mx#verification'
  get '/mx/accounts/:user_guid', to: 'mx#accounts'
  get '/mx/verified_accounts/:user_guid', to: 'mx#verified_accounts'
  get '/mx/accounts/generate-auth-code/:account_guid/:member_guid/:user_guid', to: 'mx#generate_auth_code'
end
