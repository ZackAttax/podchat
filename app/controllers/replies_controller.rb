class RepliesController < ApplicationController
  before_action :authenticate_user!

  def index
    @replies = current_comment.replies.includes(:user)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to episode_url(current_episode) }
    end
  end

  def hide
    @count = current_comment.replies.length
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to episode_url(current_episode) }
    end
  end

  def create
    current_user.replies.create(reply_params)

    respond_to do |format|
      format.html { redirect_to episode(current_episode) }
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

  private

  def reply_params
    params.require(:reply).permit(:content, :comment_id)
  end

  def current_episode
    current_comment.episode
  end

  def current_comment
    @current_comment ||= Comment.find_by_id(params[:comment_id])
  end
end
