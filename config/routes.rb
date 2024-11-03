Rails.application.routes.draw do
  namespace :admins do
    # get 'admin/home',  to: 'home#index'
    root 'home#index'
  end
  namespace :clients do
    # get 'client/home',  to: 'home#index'
    root 'home#index'
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "landing#index"
end
