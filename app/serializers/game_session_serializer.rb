class GameSessionSerializer < ActiveModel::Serializer
  attributes :id,
             :number,
             :date,
             :teams_count,
             :playlists_count,
             :interludes_count,
             :status

 has_many :teams, serializer: TeamSerializer
  def teams_count
    object.teams.count
  end

  def playlists_count
    object.playlists.count
  end

  def interludes_count
    object.interludes.count
  end
end
