class EpisodesController < ApplicationController
  def show
    @episode = SpotifyApi.find_episode(params[:id])
    @comments = Comment.by_episode_in_order_by_timestamp(@episode.id).includes(:user, :replies)
    @comment = Comment.new
  end

  def index
  end

  def search
  end
end
