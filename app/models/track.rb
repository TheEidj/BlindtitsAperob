class Track < ApplicationRecord
  belongs_to :playlist
  has_many :scores
end
