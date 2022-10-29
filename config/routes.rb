Rails.application.routes.draw do
  root "users#show"

  get "/listings/mine", to: "listings#mine", as: :my_listings

  resources :users, only: [:show, :index, :new, :create]
  resources :listings, only: [:show, :index, :new, :create, :edit, :update, :destroy] do
    resources :rental_requests, path: "requests", only: [:show, :index, :new, :create]
  end

  get "/requests/mine", to: "rental_requests#mine", as: :my_requests
 

  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout
end
