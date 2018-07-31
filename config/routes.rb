Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :wines, only: [:index]
      resources :regions, only: [:index]
      resources :grapes, only: [:index]

      resources :users, only: [:create]
      get "/wineries" => "wineries#index"
      get "/winery" => "wineries#return_winery_api_results"
      # post "/sessions" => ""
    end
  end


end
