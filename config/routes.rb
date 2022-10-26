Rails.application.routes.draw do
  root "users#index"

  resources :users, only: [:show, :index, :new, :create]
  resources :listings, only: [:show, :index, :new, :create] do
    resources :requests, only: [:show, :index, :new, :create]
  end

  get "/requests", to: "requests#mine", as: :my_requests

  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout
end
