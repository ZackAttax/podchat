class Reply < ApplicationRecord
  after_create_commit :append_new_reply
  belongs_to :user
  belongs_to :comment

  def append_new_reply
    broadcast_update_to(
      self.comment.episode,
      target:  "comment-#{self.comment_id}-link-to-replies",
      html: "#{ self.comment.replies.count } Reply".pluralize(self.comment.replies.count)
    )
    broadcast_append_to(
      self.comment.episode,
      target:  "#{self.comment.replies_list_id}-list",
      html: ApplicationController.render(
        ReplyComponent.new(reply: self),
        layout: false
      )
    )
  end
end
