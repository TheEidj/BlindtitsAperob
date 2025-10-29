class GameSessionsController < ApplicationController
  before_action :set_game_session, only: [ :show, :update, :destroy, :add_playlist, :remove_playlist, :add_team, :remove_team, :reorder_playlists ]

  def index
    game_sessions = GameSession.all.includes(teams: [], playlists: []).order(date: :desc)
    render json: game_sessions.map { |gs| serialize_game_session(gs) }
  end

  def show
    render json: serialize_game_session_detail(@game_session)
  end

  def create
    game_session = GameSession.new(game_session_params)

    if game_session.save
      render json: serialize_game_session(game_session), status: :created
    else
      render json: { errors: game_session.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @game_session.update(game_session_params)
      render json: serialize_game_session(@game_session)
    else
      render json: { errors: @game_session.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @game_session.destroy
    head :no_content
  end

  def add_playlist
    playlist = Playlist.find(params[:playlist_id])
    @game_session.playlists << playlist unless @game_session.playlists.include?(playlist)
    render json: serialize_game_session_detail(@game_session)
  end

  def remove_playlist
    playlist = Playlist.find(params[:playlist_id])
    @game_session.playlists.delete(playlist)
    render json: serialize_game_session_detail(@game_session)
  end

  def add_team
    team = Team.find(params[:team_id])
    @game_session.teams << team unless @game_session.teams.include?(team)
    render json: serialize_game_session_detail(@game_session)
  end

  def remove_team
    team = Team.find(params[:team_id])
    @game_session.teams.delete(team)
    render json: serialize_game_session_detail(@game_session)
  end

  def reorder_playlists
    playlist_ids = params[:playlist_ids]
    playlist_ids.each_with_index do |playlist_id, index|
      GameSessionPlaylist.find_by(game_session: @game_session, playlist_id: playlist_id)
        &.update(position: index)
    end
    render json: serialize_game_session_detail(@game_session)
  end

  private

  def set_game_session
    @game_session = GameSession.find(params[:id])
  end

  def game_session_params
    params.require(:game_session).permit(:date)
  end

  def serialize_game_session(game_session)
    {
      id: game_session.id,
      date: game_session.date,
      teams_count: game_session.teams.count,
      playlists_count: game_session.playlists.count,
      upcoming: game_session.upcoming?,
      created_at: game_session.created_at
    }
  end

  def serialize_game_session_detail(game_session)
    {
      id: game_session.id,
      date: game_session.date,
      teams: game_session.teams.map { |t| serialize_team(t) },
      playlists: game_session.playlists.map { |p| serialize_playlist(p) },
      upcoming: game_session.upcoming?,
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
      picture_url: playlist.picture_url,
      played: playlist.played
    }
  end
end
