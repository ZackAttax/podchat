require 'rspotify'
require 'net/http'
require 'uri'
class SpotifyApi

  def self.get_currently_playing(token)
    base_url = 'https://api.spotify.com/v1/me/player/currently-playing?'
    query_params = { 'additional_types' => 'episode' }
    url = URI.parse(base_url)
    url.query = URI.encode_www_form(query_params)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true  # Enable SSL if the API requires it

    request = Net::HTTP::Get.new(url, {'Authorization' => 'Bearer ' + token})

    response = http.request(request)

    if response.code.to_i == 200
      # Successful response
      JSON.parse(response.body)
    else
      # Handle errors
      puts "Error: #{response.code}, #{response.body}"
    end
  end

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
