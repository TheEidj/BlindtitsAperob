# app/serializers/game_serializer.rb
class GameSerializer < ActiveModel::Serializer
  attributes :id,
             :number,
             :playlists,
             :interludes

  has_many :game_session_teams, key: :teams, serializer: GameTeamSerializer

  def playlists
    object.playlists.map do |playlist|
      PlaylistSerializer.new(playlist, scope: scope, root: false).as_json
    end
  end

  def interludes
    object.interludes.map do |interlude|
      InterludeSerializer.new(interlude, scope: scope, root: false).as_json
    end
  end
end
