class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: %i[spotify]
  has_many :comments

  def self.from_omniauth(params)
    user = User.find_or_create_by(email: params[:info][:email]) do |u|
      u.password = Devise.friendly_token[0, 20]
    end
    binding.break
    user.access_token = params[:credentials][:token]
    user.refresh_token = params[:credentials][:refresh_token]
    user.token_expires_at = params[:credentials][:token_expires_at]

    if user.save
      # Successfully updated or created user
      { message: 'Tokens updated successfully' }
    else
      # Handle validation errors or other issues
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
