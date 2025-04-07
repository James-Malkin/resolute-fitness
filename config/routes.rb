# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  get '/profile', to: 'profile#index', as: :profile
  get '/profile/edit', to: 'profile#edit', as: :profile_edit
  get '/profile/:username', to: 'profile#show', as: :profile_show

  resources :users, only: [:update] do
    member do
      patch :update_email
      patch :update_username
      delete :cancel_change_email
    end
  end

  resources :exercise_classes, only: [:index], path: 'classes'

  root to: 'home#index'

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
