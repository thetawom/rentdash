Rails.application.routes.draw do

  root to: "listings#index"

  get "/listings/mine", to: "listings#mine", as: :my_listings
  get "/requests", to: "rental_requests#mine", as: :my_requests
  get "/rentals", to: "rentals#mine", as: :my_rentals

  resources :users, only: [:show, :index, :new, :create]
  resources :listings, only: [:show, :index, :new, :create, :edit, :update, :destroy] do
    resources :rental_requests, path: "requests", only: [:show, :index, :new, :create, :destroy], shallow: true
  end
  resources :rentals, only: [:show, :index, :new, :create]

  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout
end
