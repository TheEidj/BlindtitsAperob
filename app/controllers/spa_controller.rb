class SpaController < ActionController::Base
  # Pas d'auth ici, c'est juste pour servir la SPA
  def index
    render file: Rails.public_path.join("index.html"),
           layout: false,
           content_type: "text/html"
  end
end
