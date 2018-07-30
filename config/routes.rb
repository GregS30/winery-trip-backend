Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :wines, only: [:index]
      resources :regions, only: [:index]
      resources :users, only: [:show]
      resources :grapes, only: [:index]
      get "/wineries" => "wineries#index"
      get "/winery" => "wineries#return_winery_api_results"
    end
  end


end
