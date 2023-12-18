# frozen_string_literal: true
require 'rspotify'
require 'net/http'
require 'uri'
class SpotifyApi
  BASE_URL = 'https://api.spotify.com/v1/me/player/currently-playing?'
  ACCOUNT_URL = "https://accounts.spotify.com/api/token"

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

  def self.get_refresh_token(refresh_token)
    url = URI(ACCOUNT_URL)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    request['Authorization'] = "Basic #{Base64.strict_encode64("#{ENV["SPOTIFY_ID"]}:#{ENV["SPOTIFY_SECRET"]}")}"

    request.set_form_data(
      'grant_type' => 'refresh_token',
      'refresh_token' => refresh_token,
      'client_id' => ENV["SPOTIFY_ID"]
    )

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      body = JSON.parse(response.body)
      access_token = body['access_token']
      new_refresh_token = body['refresh_token']
      expires_in = body['expires_in']

      {code: response.code, access_token: access_token, refresh_token: new_refresh_token, expires_in: expires_in}
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
