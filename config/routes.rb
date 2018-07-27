Rails.application.routes.draw do
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
      resources :regions, only: [:index]
      resources :users, only: [:show]
      get "/wineries" => "wineries#index"
      get "/winery" => "wineries#return_winery_api_results"
    end
  end


end
