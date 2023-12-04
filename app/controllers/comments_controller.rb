class CommentsController < ApplicationController
  def index
  end

  def create
    comment = Comment.create(content: params[:comment][:content], user_id: params[:comment][:user], episode: params[:comment][:episode])
    respond_to do |format|
      format.html { redirect_to episodes_show(episode: params[:comment][:episode]) }
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "comment-form",
          partial: '/comments/form',
          locals: {comment: Comment.new,
          episode_id: params[:comment][:episode],
          }
        )
      end
    end
  end
end
