# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'reports#index'
  resources :reports do
    member do
      get 'view'
      get 'export'
      get 'email'
    end
  end
end
