class GameSessionDetailSerializer < ActiveModel::Serializer
  attributes :id,
             :number,
             :date,
             :status,
             :created_at,
             :updated_at

  has_many :teams, serializer: TeamSerializer
  has_many :playlists, serializer: PlaylistSerializer
  has_many :interludes, serializer: InterludeSerializer
end
