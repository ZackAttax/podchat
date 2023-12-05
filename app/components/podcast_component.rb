# frozen_string_literal: true

class PodcastComponent < ViewComponent::Base
  def initialize(podcast:)
    @podcast = podcast
  end

end
