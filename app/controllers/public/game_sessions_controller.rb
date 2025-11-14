
module Public
  class GameSessionsController < ApplicationController
    skip_before_action :authorize_request, only: [ :featured, :upcoming, :ongoing, :archived ]

    def featured
      game_session = GameSession.ongoing.or(GameSession.upcoming).order(date: :asc).first

      if game_session
        render json: game_session, serializer: GameSessionSerializer, status: :ok
      else
        render json: { message: "No ongoing or upcoming game sessions" }, status: :ok
      end
    end
    def upcoming
      game_sessions = GameSession.upcoming.order(date: :asc).first

      if game_sessions
        render json: game_sessions, each_serializer: GameSessionSerializer, status: :ok
      else
        render json: { message: "No upcoming game sessions" }, status: :ok
      end
    end

    def ongoing
      game_session = GameSession.ongoing.order(date: :asc).first

      if game_session
        render json: game_session, serializer: GameSessionSerializer, status: :ok
      else
        render json: { message: "No ongoing game sessions" }, status: :ok
      end
    end

    def archived
      game_sessions = GameSession.archived

      if game_sessions
        render json: game_sessions, each_serializer: GameSessionSerializer, status: :ok
      else
        render json: { message: "No archived game sessions" }, status: :ok
      end
    end
  end
end
