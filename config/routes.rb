Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  post "/user/login", to: "users#login"
  get "/user/details", to: "users#me"
  resources :orders
end
