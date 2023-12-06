class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: %i[spotify]

  def self.from_omniauth(response)
    User.find_or_create_by(email: response[:info][:email]) do |u|
      u.password = Devise.friendly_token[0, 20]
    end
  end
end
