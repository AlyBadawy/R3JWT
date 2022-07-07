Rails.application.routes.draw do
  root "react#index", as: :react_index
  get "*path", to: "react#index"
end
