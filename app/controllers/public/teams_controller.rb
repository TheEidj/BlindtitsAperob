module Public
  class TeamsController < ApplicationController
    skip_before_action :authorize_request, only: [ :create ]

    def create
      game_session = GameSession.find(params[:game_session_id])

      team = Team.new(team_params)

      if team.save
        game_session.teams << team
        render json: {
          id: team.id,
          name: team.name,
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
  end
end
