class EpisodesController < ApplicationController
  def show
    @episode = SpotifyApi.find_episode(params[:id])
    @comments = Comment.where(episode: params[:id]).all
    @comment = Comment.new

  end

  def index
  end

  def search
  end
end
