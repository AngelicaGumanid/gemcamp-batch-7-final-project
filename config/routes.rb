Rails.application.routes.draw do

  constraints(AdminDomainConstraint.new) do
    namespace :admins do

      devise_for :users, controllers: { sessions: 'admins/sessions' }, skip: [:registrations]

      resources :users do
        post 'clients/:id/increase', to: 'balance_operate#increase', as: 'increase'
        post 'clients/:id/deduct', to: 'balance_operate#deduct', as: 'deduct'
        post 'clients/:id/bonus', to: 'balance_operate#bonus', as: 'bonus'
        post 'clients/:id/share_bonus', to: 'balance_operate#share_bonus', as: 'share_bonus'
      end

      resources :items do
        member do
          patch :restore
          patch :start
          patch :pause
          patch :end
          patch :cancel
          patch :resume
        end
      end

      resources :categories do
        member do
          patch :restore
        end
      end

      resources :tickets do
        member do
          patch :cancel
        end
      end

      resources :winners do
        member do
          patch :submit
          patch :pay
          patch :ship
          patch :deliver
          patch :publish
          patch :remove_publish
        end
      end

      resources :offers

      resources :orders do
        member do
          patch :submit
          patch :pay
          patch :cancel
        end
      end

      get 'invite_list', to: 'invite_list#index'

      resources :news_tickers do
        member do
          patch :restore
        end
      end

      resources :banners do
        member do
          patch :restore
        end
      end


    end
    root to: 'admins/home#index', as: 'admin_root'
  end

  constraints(ClientDomainConstraint.new) do
    namespace :clients do

      devise_for :users, controllers: { registrations: 'clients/registrations', sessions: 'clients/sessions' }

      resource :profiles, only: [:show, :edit, :update], controller: 'profiles'

      namespace :profiles do
        resources :order_history, only: [:index]
        resources :lottery_history, only: [:index]
        resources :invite_list, only: [:index]
        resources :winnings_list, only: [:index, :edit, :update] do
          member do
            get 'share', to: 'winnings_list#share_form'
            patch 'share', to: 'winnings_list#share'
          end
        end
      end

      resources :locations, only: [:index, :new, :create, :edit, :update, :destroy]

      get 'invite/people', to: 'invite#index', as: 'invite_people'

      resources :lotteries, only: [:index, :show] do
        post 'buy_ticket', on: :member
      end

      resources :shops, only: [:index, :show] do
        post 'purchase', on: :member
      end

      resources :orders, only: [:create] do
        member do
          patch :cancel
        end
      end

      resources :shares, only: [:index, :show]

    end
    root to: 'clients/home#index'
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
end
