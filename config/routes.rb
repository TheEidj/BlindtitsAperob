Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  defaults format: :json do
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
  end

  # Root redirect to Vue.js app
  root to: redirect("/app/")

  # Serve Vue.js app for all other HTML requests
  get "*path", to: "application#fallback_index_html", constraints: ->(request) do
    request.format.html?
  end
end
