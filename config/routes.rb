Rails.application.routes.draw do
  resources :grapes
  resources :wineries
  # resources :regions
  # resources :trip_wineries
  # resources :wines
  # resources :wineries
  # resources :trips
  # resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :wines, only: [:index]
      resources :wineries, only: [:index, :show]
      resources :regions, only: [:index]
      resources :users, only: [:show]
    end
  end


end
