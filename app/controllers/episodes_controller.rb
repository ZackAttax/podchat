class EpisodesController < ApplicationController
  before_action :authenticate_user!

  def show
    @episode = SpotifyApi.find_episode(params[:id])
    add_breadcrumb "Search", podcasts_search_path
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
