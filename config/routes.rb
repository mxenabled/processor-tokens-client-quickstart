Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "login#index"

  resources :users

  # View a user's information
  get "/dashboard", to: "dashboard#index"

end
