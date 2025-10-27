Rails.application.routes.draw do
  get "/me", to: "users#me"
  post "/login", to: "auth#login"
  resources :teams
  resources :game_sessions
  resources :tracks
  resources :playlists do
    collection do
      post :refresh_all
    end
    member do
      patch :toggle_played
      get :oembed
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # Serve Vue.js app for all non-API routes
  get "*path", to: "application#fallback_index_html", constraints: ->(request) do
    !request.xhr? && request.format.html?
  end
end
