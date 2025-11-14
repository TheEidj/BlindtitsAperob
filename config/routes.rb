Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  defaults format: :json do
    get "/me", to: "users#me"
    post "/login", to: "auth#login"
    resources :teams
    resources :game_sessions do
      member do
        post :add_playlist
        delete "remove_playlist/:playlist_id", action: :remove_playlist
        patch :reorder_playlists
        post :add_interlude
        delete "remove_interlude/:interlude_id", action: :remove_interlude
        patch :reorder_interludes
        post :add_team
        delete "remove_team/:team_id", action: :remove_team
        patch "reorder_playlists"
      end
    end
    resources :tracks
    resources :interludes
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

  scope :game do
    post ":id/start", to: "game#start"
    post ":id/end", to: "game#end"
    post ":id/:team_id/score", to: "game#update_score"
  end

  # Public routes (no auth required)
  namespace :public do
    get "game_sessions/ongoing", to: "game_sessions#ongoing"
    get "game_sessions/upcoming", to: "game_sessions#upcoming"
    get "game_sessions/archived", to: "game_sessions#archived"
    get "game_sessions/featured", to: "game_sessions#featured"
    post "teams", to: "teams#create"
  end

  # Catch-all pour Vue.js (doit être EN DERNIER)
  get "*path", to: "application#fallback_index_html", constraints: ->(request) do
    !request.xhr? && request.format.html?
  end

  root to: "application#fallback_index_html"
end
