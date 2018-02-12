Rails.application.routes.draw do

  devise_for :users,
             controllers: {
               invitations: 'admin/invitations'
             }

  devise_scope :user do
    authenticated :user do
      root 'user/dashboard#show', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  namespace :user do
    get '/dashboard', to: 'dashboard#show'
  end

  root to: 'user/dashboard#show'

  namespace :admin do
    get '/users', to: 'users#index'

    root to: 'users#index'
  end

end
