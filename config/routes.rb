Rails.application.routes.draw do
  get 'sessions/new'
  root 'home#home'
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :sessions, only: [ :new, :create, :destroy ]
  resources :posts, only: [:new, :create, :destroy]
  resources :relationships, only: [:create, :destroy]
end
