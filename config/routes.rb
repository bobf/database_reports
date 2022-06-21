# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }, skip: [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end

  get '/healthcheck', to: proc { [200, {}, ['']] }

  root to: 'reports#index'

  resources :reports do
    resources :exports do
      member do
        get 'export'
      end
    end

    member do
      get 'view'
      get 'export'
      get 'email'
    end
  end

  resources :users
  resources :databases
end
