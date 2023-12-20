# frozen_string_literal: true

class CommentComponent < ViewComponent::Base
  def initialize(comment:)
    @comment = comment
  end

  def reply_or_replies
    count = @comment.replies.length
    pluralize(count, "Reply")
  end

  def comment_replies_list_id
    @comment.replies_list_id
  end
end
