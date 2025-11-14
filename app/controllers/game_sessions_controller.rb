class GameSessionsController < ApplicationController
  before_action :set_game_session, only: [ :show, :update, :destroy, :add_playlist, :remove_playlist, :add_team, :remove_team, :reorder_playlists ]

  def index
    game_sessions = GameSession.all.includes(teams: [], playlists: []).order(date: :asc)
    render json: game_sessions, each_serializer: GameSessionSerializer, scope: @current_user
  end

  def show
    render json: @game_session, serializer: GameSessionDetailSerializer, scope: @current_user
  end

  def create
    game_session = GameSession.new(game_session_params)

    if game_session.save
      render json: game_session, serializer: GameSessionSerializer, scope: @current_user, status: :created
    else
      render json: { errors: game_session.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @game_session.update(game_session_params)
      render json: @game_session, serializer: GameSessionSerializer, scope: @current_user
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
    render json: @game_session, serializer: GameSessionDetailSerializer, scope: @current_user
  end

  def remove_playlist
    playlist = Playlist.find(params[:playlist_id])
    @game_session.playlists.delete(playlist)
    render json: @game_session, serializer: GameSessionDetailSerializer, scope: @current_user
  end

  def add_interlude
    @game_session = GameSession.find(params[:id])
    interlude = Interlude.find(params[:interlude_id])

    @game_session.interludes << interlude unless @game_session.interludes.include?(interlude)

    render json: @game_session, serializer: GameSessionDetailSerializer
  end

  def remove_interlude
    @game_session = GameSession.find(params[:id])
    interlude = Interlude.find(params[:interlude_id])

    @game_session.interludes.delete(interlude)

    render json: @game_session, serializer: GameSessionDetailSerializer
  end

  def add_team
    team = Team.find(params[:team_id])
    @game_session.teams << team unless @game_session.teams.include?(team)
    render json: @game_session, serializer: GameSessionDetailSerializer, scope: @current_user
  end

  def remove_team
    team = Team.find(params[:team_id])
    @game_session.teams.delete(team)
    render json: @game_session, serializer: GameSessionDetailSerializer, scope: @current_user
  end

  def reorder_playlists
    @game_session = GameSession.find(params[:id])
    playlist_ids = params[:playlist_ids]

    playlist_ids.each_with_index do |playlist_id, index|
      game_session_playlist = @game_session.game_session_playlists.find_by(playlist_id: playlist_id)
      game_session_playlist&.update(position: index)
    end

    render json: @game_session, serializer: GameSessionDetailSerializer
  end

  def reorder_interludes
    @game_session = GameSession.find(params[:id])
    interlude_ids = params[:interlude_ids]

    interlude_ids.each_with_index do |interlude_id, index|
      game_session_interlude = @game_session.game_session_interludes.find_by(interlude_id: interlude_id)
      game_session_interlude&.update(position: index)
    end

    render json: @game_session, serializer: GameSessionDetailSerializer
  end

  private

  def set_game_session
    @game_session = GameSession.find(params[:id])
  end

  def game_session_params
    params.require(:game_session).permit(:date, :status, :number)
  end
end
