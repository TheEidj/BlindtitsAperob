# frozen_string_literal: true

require "net/http"
require "json"

class DeezerService
  BASE_URL = "https://api.deezer.com"

  def initialize(user)
    @user = user
  end

  def fetch_playlists
    return [] unless @user.deezer_id.present?

    url = URI("#{BASE_URL}/user/#{@user.deezer_id}/playlists?limit=400")
    res = Net::HTTP.get_response(url)
    return [] unless res.is_a?(Net::HTTPSuccess)

    JSON.parse(res.body)["data"]
  end
end
