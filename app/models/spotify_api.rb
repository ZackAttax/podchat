require 'rspotify'
class SpotifyApi

  def self.search_shows(params)
    RSpotify::Show.search(params, market: "US")
  end

  def self.find_show(id)
    RSpotify::Show.find(id, market: "US")
  end

  def self.find_episode(id)
    RSpotify::Episode.find(id, market: "US")
  end
end
