
module Public
  class GameSessionsController < ApplicationController
    skip_before_action :authenticate_user!, only: [ :upcoming, :past ]

    def upcoming
      game_session = GameSession.upcoming.includes(teams: []).first

      if game_session
        render json: serialize_game_session(game_session), status: :ok
      else
        render json: { message: "No upcoming game sessions" }, status: :ok
      end
    end

    def past
      game_sessions = GameSession.past.includes(teams: [], playlists: [])
      render json: game_sessions.map { |gs| serialize_game_session(gs) }, status: :ok
    end

    private

    def serialize_game_session(game_session)
      {
        id: game_session.id,
        date: game_session.date,
        teams: game_session.teams.map { |t| serialize_team(t) },
        playlists: game_session.playlists.map { |p| serialize_playlist(p) },
        created_at: game_session.created_at,
        updated_at: game_session.updated_at
      }
    end

    def serialize_team(team)
      {
        id: team.id,
        name: team.name,
        color: team.color,
        player_count: team.player_count || 0
      }
    end

    def serialize_playlist(playlist)
      {
        id: playlist.id,
        name: playlist.name,
        deezer_id: playlist.deezer_id,
        picture_url: playlist.picture_url
      }
    end
  end
end
