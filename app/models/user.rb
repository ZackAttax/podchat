class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: %i[spotify]
  has_many :comments

  def self.from_omniauth(params)
    user = User.find_or_initialize_by(email: params[:info][:email]) do |u|
      u.spotify_uid = params[:info][:uid]
      u.password = Devise.friendly_token[0, 20]
    end
    user.access_token = params[:credentials][:token]
    user.refresh_token = params[:credentials][:refresh_token]
    user.token_expires_at = params[:credentials][:token_expires_at]

    if user.save
      user
    else
      { error: user.errors.full_messages }
    end
  end
end
