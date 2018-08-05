Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :wines, only: [:index]

      get "/wineries" => "wineries#index"
      get "/winery" => "wineries#return_winery_api_results"
      post "/signup" => "users#create"
      get "/users" => "users#index"
      post "/sessions" => "sessions#create"
      get "/current_user" => "users#current_user"
      post "/users/:id/wineries" => "wineries#create"
      get "/users/:id/wineries" => "wineries#show"
      get "/grapes_regions" => "grapes_regions#index"

    end
  end

end
