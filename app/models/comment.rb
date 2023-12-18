# frozen_string_literal: true
class Comment < ApplicationRecord
  belongs_to :user
  before_create :check_currently_playing
  after_create_commit :append_new_comment
  scope :by_episode_in_order_by_timestamp, ->(episode) { where(episode: episode).order(timestamp: :asc) }

  def human_readable_timestamp
    seconds = self.timestamp / 1000
    hours = seconds / 3600
    minutes = (seconds % 3600) / 60
    remaining_seconds = seconds % 60

    sprintf('%02d:%02d:%02d', hours, minutes, remaining_seconds)
  end

  private

  def check_currently_playing
    # Fetch currently playing episode and timestamp if the user has an access token
  episode_and_timestamp = user.get_currently_playing_episode_and_timestamp if user.access_token.present?

  # Update timestamp if the episode ID matches the currently playing episode
  if episode_and_timestamp.present? && episode_and_timestamp[:id] == episode
    self.timestamp = episode_and_timestamp[:timestamp]
  end
  end

  def find_closest_comment_id
    Comment
      .where.not(id: id)
      .where("timestamp <= ? AND episode = ?", timestamp, episode)
      .order(timestamp: :desc, created_at: :desc)
      .select(:id)
      .first&.id
  end

  def append_new_comment
    broadcast_append_to(
      self.episode,
      target: determine_target_value,
      html: ApplicationController.render(
        CommentComponent.new(comment: self),
        layout: false
      )
    )
  end

  def determine_target_value
    # if there is no closest comment the target value is the comment list
    find_closest_comment_id || "comment-list"
  end
end
