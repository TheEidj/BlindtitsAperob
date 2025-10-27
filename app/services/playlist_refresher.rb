# frozen_string_literal: true

class PlaylistRefresher
  def self.refresh_all(current_user)
    users = User.where.not(deezer_id: nil)
    users.each { |u| refresh_for_user(u) }

    mark_followed_playlists(current_user)
  end

  def self.refresh_for_user(user)
    deezer = DeezerService.new(user)
    playlists = deezer.fetch_playlists
    playlists = playlists.select { |p| p["title"].to_s.downcase.start_with?("ba -") }

    playlists.each do |p|
      pl = Playlist.find_or_initialize_by(deezer_id: p["id"])
      pl.assign_attributes(
        name: p["title"].sub(/^BA\s*-\s*/i, "").strip,
        url: p["link"],
        nbTrack: p["nb_tracks"],
        played: false,
        collaborative: p["collaborative"],
        creator: p.dig("creator", "id").to_s,
        deezer_id: p["id"].to_s
      )
      pl.save!

      # TODO: use p["tracklist"] to create tracks in db
    end
  end

  def self.mark_followed_playlists(user)
    deezer = DeezerService.new(user)
    playlists = deezer.fetch_playlists

    playlists.each do |p|
      playlist = Playlist.find_by(deezer_id: p["id"].to_s)
      next unless playlist

      UserPlaylist.find_or_create_by(user: user, playlist: playlist)
    end
  end
end
