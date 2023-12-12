# frozen_string_literal: true

class SpotifyPlayerComponent < ViewComponent::Base
  def initialize(user:, episode:)
    @user = user
    @episode = episode
  end

end
