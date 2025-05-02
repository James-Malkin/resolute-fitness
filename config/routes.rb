# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: 'users/confirmations'
  }

  get 'up' => 'rails/health#show', as: :rails_health_check
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  get '/profile/edit', to: 'profile#edit', as: :profile_edit
  get '/:username', to: 'profile#show', as: :profile_show

  get '/staff', to: 'staff_tools#index', as: :staff_tools
  # get '/staff/schedule/new', to: 'class_schedules#new', as: :new_class_schedule
  # post '/staff/schedule', to: 'class_schedules#create', as: :class_schedules

  resources :class_schedules, only: %i[index new create]
  resources :bookings, only: %i[new create]

  resources :users, only: [:update] do
    member do
      patch :update_email
      patch :update_username
      delete :cancel_change_email
    end
  end

  resources :plans, only: [:index] do
    get :join, on: :collection
  end

  resources :members, only: [:update] do
    post :subscribe, on: :member
  end

  resources :exercise_classes, only: %i[index new create edit update], path: 'classes'

  resources :payment_methods, only: %i[new create], path: 'payment-methods'

  get '/test', to: 'home#test', as: :test

  root to: 'home#index'
end
