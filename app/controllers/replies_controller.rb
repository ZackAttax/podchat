class RepliesController < ApplicationController
  def index
    @replies = current_comment.replies
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to episodes_show_url(current_episode) }
    end
  end

  def hide
    @count = current_comment.replies.count
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to episodes_show_url(current_episode) }
    end
  end

  def create
    current_user.replies.create(reply_params)

    respond_to do |format|
      format.html { redirect_to episodes_show(current_episode) }
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "reply-form",
          partial: '/replies/form',
          locals: {reply: Reply.new,
          comment: current_comment,
          }
        )
      end
    end
  end

  def reply_params
    params.require(:reply).permit(:content, :comment_id)
  end

  def reply_or_replies
    count = current_comment.replies.count
    if count == 0
      "Reply"
    else
      "#{count} #{pluralize(count, "Reply")}"
    end
  end

  def comment_replies_list_id
    current_comment.replies_list_id
  end

  def current_episode
    current_comment.episode
  end

  def current_comment
    @current_comment ||= Comment.find_by_id(params[:comment_id])
  end
end
