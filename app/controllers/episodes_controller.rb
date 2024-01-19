class EpisodesController < ApplicationController
  before_action :authenticate_user!
  before_action :add_search_to_breadcrumb

  def show
    @episode = SpotifyApi.find_episode(params[:id])
    add_breadcrumb @episode.show.name, podcasts_show_url(@episode.show.id)
    add_breadcrumb @episode.name, episode_url(@episode.id)
    @comments = Comment.by_episode_in_order_by_timestamp(@episode.id).includes(:user, :replies)
    @comment = Comment.new
  end

  def index
  end

  def search
  end
end
