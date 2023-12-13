# frozen_string_literal: true
class Comment < ApplicationRecord
  belongs_to :user
  before_create :check_currently_playing
  after_create_commit :append_new_comment

  def human_readable_timestamp
    seconds = self.timestamp / 1000
    hours = seconds / 3600
    minutes = (seconds % 3600) / 60
    remaining_seconds = seconds % 60

    sprintf('%02d:%02d:%02d', hours, minutes, remaining_seconds)
  end

  private

  def check_currently_playing
    episode_and_timestamp = user.get_currently_playing_episode_and_timestamp
    if episode_and_timestamp.dig(:id) == episode
      timestamp = episode_and_timestamp[:timestamp]
    end
  end

  def append_new_comment
    broadcast_append_to(
      self.episode,
      target: "comment-list",
      html: ApplicationController.render(
        CommentComponent.new(comment: self),
        layout: false
      )
    )
  end
end
