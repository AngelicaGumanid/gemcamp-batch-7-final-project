Rails.application.routes.draw do

  namespace :admins do
    devise_for :users, controllers: { sessions: 'admins/sessions' }, skip: [:registrations]
    root 'home#index'
  end

  namespace :clients do
    devise_for :users, controllers: { registrations: 'clients/registrations', sessions: 'clients/sessions' }
    root 'home#index'
  end

  # devise_for :users
  #
  # namespace :admins do
  #   root 'home#index'
  #   devise_for :users, controllers: {
  #     sessions: 'admins/sessions'
  #   }
  # end
  #
  # namespace :clients do
  #   root 'home#index'
  #   devise_for :users, controllers: {
  #     registrations: 'clients/registrations',
  #     sessions: 'clients/sessions'
  #   }
  # end
  #
  # authenticated :user do
  #   root 'clients/home#index', as: :authenticated_root
  # end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "landing#index"
end
