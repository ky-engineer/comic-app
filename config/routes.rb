Rails.application.routes.draw do
  get 'sessions/new'
  root 'home#home'
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :users
  resources :sessions, only: [ :new, :create, :destroy ]
end
