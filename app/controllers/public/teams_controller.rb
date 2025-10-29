module Public
  class TeamsController < ApplicationController
    skip_before_action :authenticate_user!, only: [ :create ]

    def create
      game_session = GameSession.find(params[:game_session_id])

      team = Team.new(team_params)
      team.color = generate_random_color

      if team.save
        game_session.teams << team
        render json: {
          id: team.id,
          name: team.name,
          color: team.color,
          player_count: team.player_count,
          message: "Team registered successfully!"
        }, status: :created
      else
        render json: { errors: team.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def team_params
      params.require(:team).permit(:name, :player_count, :game_session_id)
    end

    def generate_random_color
      colors = [
        "#EF4444", "#F59E0B", "#10B981", "#3B82F6",
        "#8B5CF6", "#EC4899", "#06B6D4", "#F97316"
      ]
      colors.sample
    end
  end
end
