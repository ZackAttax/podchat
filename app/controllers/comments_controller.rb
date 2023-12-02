class CommentsController < ApplicationController
  def index
  end

  def create
    comment = Comment.create(content: params[:comment][:content], user_id: params[:comment][:user], episode: params[:comment][:episode])
    respond_to do |format|
      format.html { redirect_to episodes_show(episode: params[:comment][:episode]) }
      format.turbo_stream do
        render turbo_stream.append( "comment-list", CommentComponent.new(comment: comment) )
      end
    end
  end
end
