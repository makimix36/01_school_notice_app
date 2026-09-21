Rails.application.routes.draw do
  root to: "static_pages#top"
  resources :users, only: %i[new create show edit update]
  resources :notifications, only: %i[index new create]
  get "login", to: "user_sessions#new", as: "login"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy", as: "logout"
end
