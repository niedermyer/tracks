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

    get '/tracks', to: 'tracks#index', as: :tracks
    get '/tracks/:id', to: 'tracks#show', as: :track
  end

  root to: 'user/dashboard#show'

  namespace :admin do
    get '/users', to: 'users#index', as: :users
    get '/users/:id', to: 'users#show', as: :user
    get '/users/:id/edit', to: 'users#edit', as: :edit_user
    delete '/users/:id', to: 'users#destroy', as: :destroy_user
    post '/users/:user_id/duplicate_invitation', to: 'users/duplicate_invitations#create', as: :user_duplicate_invitation

    root to: 'users#index'
  end

  # email processing
  post '/emails/inbox', to: 'griddler/emails#create'
end
