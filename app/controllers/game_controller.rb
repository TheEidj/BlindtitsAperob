# app/controllers/game_controller.rb
class GameController < ApplicationController
  before_action :set_game_session

  PALETTE = %w[
  #F97316 #22C55E #3B82F6 #EAB308
  #EC4899 #8B5CF6 #06B6D4 #F97373
  ].freeze
  # POST /game/:id/start
  def start
    assign_colors_for_session!
    @game_session.update!(status: :ongoing)
    render json: @game_session, serializer: GameSerializer, scope: @current_user
  end

  # POST /game/:id/end
  def end
    @game_session.update!(status: :archived)
    render json: @game_session, serializer: GameSerializer, scope: @current_user
  end

  # POST /game/:id/:team_id/score
  # body JSON attendu : { "delta": 1 } ou { "delta": -1 }
  def update_score
    team = @game_session.teams.find(params[:team_id])
    delta = params[:delta].to_i

    score = Score.find_or_initialize_by(
      game_session: @game_session,
      team: team
    )

    score.points = (score.points || 0) + delta
    score.save!

    render json: @game_session, serializer: GameSerializer, scope: @current_user
  end

  private

  def set_game_session
    @game_session = GameSession
                      .includes(:teams, :playlists, :interludes)
                      .find(params[:id])
  end

  def assign_colors_for_session!
    # game_session_teams qui n'ont pas de color
    session_teams = @game_session.game_session_teams.to_a
    used_colors = session_teams.map(&:color).compact

    available_colors = PALETTE.dup

    # retirer celles déjà utilisées dans cette session
    used_colors.each do |c|
      available_colors.delete(c)
    end

    session_teams.each do |gst|
      next if gst.color.present?

      color = available_colors.shift || PALETTE.sample
      gst.update!(color: color)
    end
  end
end
