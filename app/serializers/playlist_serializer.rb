class PlaylistSerializer < ActiveModel::Serializer
  attributes :id, :name, :deezer_id, :creator, :creator_name, :url, :nbTrack,
             :is_mine, :is_followed, :played, :is_collaborative

  def is_mine
    return false if current_user.nil?
    object.created_by?(current_user)
  end

  def is_followed
    return false if current_user.nil?
    object.followed_by?(current_user)
  end

  def is_collaborative
    object.collaborative
  end

  def creator_name
    return nil if object.creator.nil?
    user = User.find_by(deezer_id: object.creator.to_s)
    user&.user_name
  end

  private

  def current_user
    scope
  end
end
