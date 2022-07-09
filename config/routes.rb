Rails.application.routes.draw do
  scope "api" do
    post "account", to: "account#create"
    put "account", to: "account#update"
    delete "account", to: "account#destroy"

    resources :users
  end
  root "react#index", as: :react_index
  get "*path", to: "react#index"
end
