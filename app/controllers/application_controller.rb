class ApplicationController < ActionController::API
  before_action :authorize_request

  def authorize_request
    header = request.headers["Authorization"]
    header = header.split(" ").last if header
    decoded = JsonWebToken.decode(header)
    if decoded && decoded[:user_id]
      @current_user = User.find_by(id: decoded[:user_id])
      unless @current_user
        render json: { error: "User not found" }, status: :unauthorized
      end
    else
      render json: { error: "Unauthorized or expired token" }, status: :unauthorized
    end
  end

  def fallback_index_html
    render file: Rails.public_path.join("app", "index.html"), layout: false, content_type: "text/html"
  end
end
