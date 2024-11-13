Rails.application.routes.draw do

  constraints(AdminDomainConstraint.new) do
    namespace :admins do
      devise_for :users, controllers: { sessions: 'admins/sessions' }, skip: [:registrations]
      root 'home#index'
    end
  end

  constraints(ClientDomainConstraint.new) do
    namespace :clients do
      devise_for :users, controllers: { registrations: 'clients/registrations', sessions: 'clients/sessions' }
      resource :profile, only: [:show, :edit, :update], controller: 'profiles'
      resources :locations, only: [:index, :new, :create, :edit, :update, :destroy]
      get 'invite=people', to: 'invite#index', as: 'invite_people'
      root 'home#index'
    end
  end

  namespace :api do
    namespace :v1 do
      resources :regions, only: %i[index show], defaults: { format: :json } do
        resources :provinces, only: :index, defaults: { format: :json }
      end

      resources :provinces, only: %i[index show], defaults: { format: :json } do
        resources :cities, only: :index, defaults: { format: :json }
      end

      resources :cities, only: %i[index show], defaults: { format: :json } do
        resources :barangays, only: :index, defaults: { format: :json }
      end

      resources :barangays, only: %i[index show], defaults: { format: :json }
    end
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
  root to: redirect('http://client.com:3000/clients/')
end
