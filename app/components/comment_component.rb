# frozen_string_literal: true

class CommentComponent < ViewComponent::Base
  def initialize(comment:)
    @comment = comment
  end

  def reply_or_replies
    count = @comment.replies.count
    if count == 0
      "Reply"
    else
      "#{count} #{pluralize(count, "Reply")}"
    end
  end

  def comment_replies_list_id
    @comment.replies_list_id
  end
end
