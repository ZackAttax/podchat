class RepliesController < ApplicationController
  def index
    @replies = current_comment.replies
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to episodes_show_url(current_episode) }
    end
  end

  def hide
    @reply_or_replies = reply_or_replies
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to episodes_show_url(current_episode) }
    end
  end

  def create
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
