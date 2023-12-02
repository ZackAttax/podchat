class Comment < ApplicationRecord
  belongs_to :user
  after_create_commit :append_new_comment

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
