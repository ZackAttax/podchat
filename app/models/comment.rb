class Comment < ApplicationRecord
  belongs_to :user
  after_create_commit :append_new_comment

  def timstamp_hour_minute_second
    seconds = self.timestamp / 1000
    hours = seconds / 3600
    minutes = (seconds % 3600) / 60
    remaining_seconds = seconds % 60

    sprintf('%02d:%02d:%02d', hours, minutes, remaining_seconds)
  end

  private

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
