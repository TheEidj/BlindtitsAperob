class PlaylistsController < ApplicationController
  skip_before_action :authorize_request, only: [ :oembed ]
  before_action :set_playlist, only: %i[ show update destroy toggle_played ]

  # GET /playlists
  def index
    @playlists = Playlist.all

    render json: @playlists,
           each_serializer: PlaylistSerializer,
           scope: @current_user
  end

  # GET /playlists/1
  def show
    render json: @playlist, serializer: PlaylistSerializer, scope: @current_user
  end

  # POST /playlists
  def create
    @playlist = Playlist.new(playlist_params)

    if @playlist.save
      render json: @playlist, status: :created, location: @playlist
    else
      render json: @playlist.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /playlists/1
  def update
    if @playlist.update(playlist_params)
      render json: @playlist
    else
      render json: @playlist.errors, status: :unprocessable_content
    end
  end

  # DELETE /playlists/1
  def destroy
    @playlist.destroy!
  end

  # PATCH /playlists/:id/toggle_played
  def toggle_played
    @playlist.update!(played: !@playlist.played)
    render json: @playlist, serializer: PlaylistSerializer, scope: @current_user
  end

  def refresh_all
    PlaylistRefresher.refresh_all(@current_user)

    @playlists = Playlist.all
    render json: @playlists, each_serializer: PlaylistSerializer, scope: @current_user
  end

  # GET /playlists/:id/oembed
  def oembed
    playlist = Playlist.find(params[:id])

    require "net/http"
    require "uri"

    encoded_url = URI.encode_www_form_component(playlist.url)
    oembed_url = "https://api.deezer.com/oembed?url=#{encoded_url}&maxwidth=400&maxheight=500&tracklist=true&format=json"

    uri = URI.parse(oembed_url)
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      render json: JSON.parse(response.body)
    else
      render json: { error: "Failed to fetch oEmbed data" }, status: :bad_gateway
    end
  rescue StandardError => e
    Rails.logger.error("oEmbed fetch error: #{e.message}")
    render json: { error: e.message }, status: :internal_server_error
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
      @playlist = Playlist.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def playlist_params
      params.expect(playlist: [ :name, :nbTrack, :played, :url ])
    end
end
