class ApplicationController < ActionController::API
  protect_from_forgery with: :exception
  before_action :authorize_request
  skip_before_action :authorize_request, only: [ :fallback_index_html ]
  def fallback_index_html
    render file: Rails.root.join("public", "index.html"), layout: false, content_type: "text/html"
  end

  private

  def authorize_request
    header = request.headers["Authorization"]
    token = header.to_s.split(" ").last
    decoded = JsonWebToken.decode(token)
    @current_user = decoded && User.find_by(id: decoded[:user_id])
    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end

  def current_user
    @current_user
  end
end
