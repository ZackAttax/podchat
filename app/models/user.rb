# frozen_string_literal: true
require 'date'
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: %i[spotify]
  has_many :comments
  has_many :replies


  def self.from_omniauth(params)
    user = User.find_or_initialize_by(email: params[:info][:email]) do |user|
      user.spotify_serid = params[:uid]
      user.password = Devise.friendly_token[0, 20]
      user.skip_confirmation!
    end
    user.access_token = params[:credentials][:token]
    user.refresh_token = params[:credentials][:refresh_token]
    user.token_expires_at = Time.at(params[:credentials][:expires_at])
    user.save
    user
  end

  def get_currently_playing_episode_and_timestamp
    response = self.get_currently_playing
    id = response.dig('item', 'id')
    timestamp = response.dig('progress_ms')
    { id: id, timestamp: timestamp }
  end

  def get_currently_playing
    check_token
    response = SpotifyApi.get_currently_playing(self.access_token)
    if response[:code] == "401"
      refresh_response = SpotifyApi.get_refresh_token(self.refresh_token)
      update_tokens(refresh_response) if refresh_response[:code] == "200"
      SpotifyApi.get_currently_playing(self.access_token)
    else
      response
    end
  end

  def check_token
    if token_expired?
      refresh_response = SpotifyApi.get_refresh_token(self.refresh_token)
      update_tokens(refresh_response) if refresh_response[:code] == "200"
    end
  end

  def update_tokens(response)
    self.access_token = response[:access_token]
    self.refresh_token = response[:refresh_token] if response[:refresh_token].present?
    self.token_expires_at = Time.now + response[:expires_in]
    self.save
  end

  def token_expired?
    current_datetime = DateTime.now
    token_expires_at < current_datetime
  end
end
