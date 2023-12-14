# frozen_string_literal: true
class Comment < ApplicationRecord
  belongs_to :user
  before_create :check_currently_playing
  after_create_commit :append_new_comment
  scope :by_episode_in_order_by_timestamp, ->(episode) { where(episode: episode).order(timestamp: :asc) }
  scope :closest_timestamp_less_than_current, ->(excluded_id, current_timestamp, episode) do
    where.not(id: excluded_id)
    .where(timestamp: (..current_timestamp), episode: episode)
    .order(timestamp: :desc, created_at: :desc)
    .pluck(:id)
    .first
  end

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
    self.timestamp = episode_and_timestamp[:timestamp] if episode_and_timestamp[:id] == episode
  end

  def find_closest_comment_id
    Comment
      .where.not(id: id)
      .where("timestamp <= ? AND episode = ?", timestamp, episode)
      .order(timestamp: :desc, created_at: :desc)
      .pluck(:id)
      .first
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
    find_closest_comment_id || "comment-list"
  end
end
