Rails.application.routes.draw do
  root to: 'users#index'

  resources :users

  get  :login,    to: "users#login"
  get  :logout,   to: "users#logout"
  post :signin,   to: "users#authenticate"

end
