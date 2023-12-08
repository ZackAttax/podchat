class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :spotify

  def spotify
    @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      session[:user_id] = @user.id
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Spotify") if is_navigational_format?
    else
      session["devise.spotify"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end

  protected
  def after_omniauth_failure_path_for(_scope)
    new_user_session_path
  end
  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end
  private
  def auth
    @auth ||= request.env['omniauth.auth']
  end

end
