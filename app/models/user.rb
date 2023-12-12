require 'date'
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: %i[spotify]
  has_many :comments

  def self.from_omniauth(params)
    user = User.find_or_initialize_by(email: params[:info][:email]) do |u|
      u.spotify_uid = params[:uid]
      u.password = Devise.friendly_token[0, 20]
    end
    user.access_token = params[:credentials][:token]
    user.refresh_token = params[:credentials][:refresh_token]
    user.token_expires_at = Time.at(params[:credentials][:expires_at])
    if user.save
      user
    else
      { error: user.errors.full_messages }
    end
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
    self.token_expires_at < current_datetime
  end
end
