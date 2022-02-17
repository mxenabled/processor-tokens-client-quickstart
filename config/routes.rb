Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Processor Tokens Demo routes
  # The general flow of getting started with processor tokens is to
  # 1: You need an MX user
  # 2: The user needs to connect a Member (Use MXConnect Widget in "aggregation" mode)
  # 3: The Member needs to be verified (Use MXConnect Widget in "verification" mode)
  # 4: The user would select an account to generate an Auth Code
  # 5: Share this auth code with the Payment Processor you're working with

  # Start at the welcome screen
  # Shows instructions for using the demo
  root "welcome#index"

  # Create, and View your MX Users
  # Viewing a specific user will allow you to Connect and Verify a Member as if you were them
  resources :users

  # View a user's information
  get "/dashboard", to: "dashboard#index"

  # MX endpoints
  get "/mx/aggregation/:user_guid", to: "mx#aggregation"
  get "/mx/verification/:user_guid", to: "mx#verification"
  get "/mx/accounts/:user_guid", to: "mx#accounts"
end
