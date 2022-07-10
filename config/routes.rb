Rails.application.routes.draw do
  scope "api" do
    post "account", to: "account#create" # Sign Up
    put "account", to: "account#update" # update account info
    delete "account", to: "account#destroy" # delete account

    resources :sessions, except: [:update]
    put "sessions", to: "sessions#update"

    resources :users
  end

  root "react#index", as: :react_index
  get "*path", to: "react#index"
end
