require 'rspotify'
class SpotifyApi

  def self.search_shows(params)
    RSpotify::Show.search(params[:q], market: params[:market] || "US")
  end

end
