Rails.application.routes.draw do

  devise_for :users

  namespace :user do
    get '/dashboard', to: 'dashboard#show'
  end

  root to: 'public#home'

end
