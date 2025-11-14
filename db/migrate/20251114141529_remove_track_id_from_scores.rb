class RemoveTrackIdFromScores < ActiveRecord::Migration[8.0]
  def change
    remove_reference :scores, :track, foreign_key: true
  end
end
