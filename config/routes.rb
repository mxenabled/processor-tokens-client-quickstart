Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "login#index"

  get "/register", to: "register#index"
  get "/dashboard", to: "dashboard#index"
end
