Rails.application.routes.draw do
  get "home/index"
  devise_for :users

  get "/users/account", to: "users#account", as: :users_account
  get "/users/profile", to: "users#profile", as: :users_profile

  get "/users/profile/edit", to: "users#edit_profile", as: :edit_users_profile
  patch "/users/profile", to: "users#update_profile", as: :users_profile_update

  resources :rooms, only: %i[index show new create edit update destroy] do
    collection do
      get :own
      get :search
    end

    resources :reservations, only: %i[create]
  end

  resources :reservations, only: %i[index edit update destroy] do
    collection do
      match :confirm, via: [:get, :post]
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")

  root "home#index"
end
