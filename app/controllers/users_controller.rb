class UsersController < ApplicationController
  def me
    render json: { id: @current_user.id, email: @current_user.email, role: @current_user.role, deezer_id: @current_user.deezer_id }
  end
end
