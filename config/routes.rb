Rails.application.routes.draw do
  scope "api" do
    resources :users
  end
  root "react#index", as: :react_index
  get "*path", to: "react#index"
end
