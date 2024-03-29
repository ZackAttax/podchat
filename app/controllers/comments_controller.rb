class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def create
    current_user.comments.create(comment_params)

    respond_to do |format|
      format.html { redirect_to episode(episode: current_episode) }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "comment-form",
          partial: '/comments/form',
          locals: {comment: Comment.new,
          episode: current_episode,
          }
        )
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:episode, :timestamp, :content)
  end

  def current_episode
    params[:comment][:episode]
  end
end
