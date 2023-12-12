require 'rspotify'
require 'net/http'
require 'uri'
class SpotifyApi
  BASE_URL = 'https://api.spotify.com/v1/me/player/currently-playing?'.freeze

  def self.get_currently_playing(token)
    query_params = { 'additional_types' => 'episode', 'market' => 'US' }
    url = URI.parse(BASE_URL)
    url.query = URI.encode_www_form(query_params)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url, {'Authorization' => 'Bearer ' + token})
    response = http.request(request)

    if response.code.to_i == 200
      JSON.parse(response.body)
    else
      {code: response.code, body: response.body}
    end
  end

  def self.search_shows(query, offset= 0, limit= 20)
    RSpotify::Show.search(query, offset: offset, limit: limit, market: "US")
  end

  def self.show_total_episodes(id)
    RSpotify.raw_response = true
    show = RSpotify::Show.find(id, market: "US")
    RSpotify.raw_response = false

    JSON.parse(show)["total_episodes"]
  end

  def self.find_show(id)
    RSpotify::Show.find(id, market: "US")
  end

  def self.find_episode(id)
    RSpotify::Episode.find(id, market: "US")
  end



end
