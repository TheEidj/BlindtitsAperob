Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  defaults format: :json do
    get "/me", to: "users#me"
    post "/login", to: "auth#login"
    resources :teams
    resources :game_sessions do
      member do
        post "add_playlist"
        delete "remove_playlist/:playlist_id", action: :remove_playlist
        post "add_team"
        delete "remove_team/:team_id", action: :remove_team
        patch "reorder_playlists"
      end
    end
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
  end

  # Public routes (no auth required)
  namespace :public do
    get "game_sessions/upcoming", to: "game_sessions#upcoming"
    get "game_sessions/past", to: "game_sessions#past"
    post "teams", to: "teams#create"
  end

  # Serve Vue.js app for all other HTML requests
  get "*path", to: "application#fallback_index_html", constraints: ->(request) do
    request.format.html?
  end

  # Root redirect to Vue.js app
  root to: "application#fallback_index_html"
end
