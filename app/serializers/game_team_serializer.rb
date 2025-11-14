class GameTeamSerializer < ActiveModel::Serializer
  attributes :team, :score, :color

  def team
    TeamSerializer.new(object.team, scope: scope, root: false).as_json
  end

  def score
    score = Score.find_by(
      game_session_id: object.game_session_id,
      team_id: object.team_id
    )
    score&.points || 0
  end

  def color
    object.color
  end
end
