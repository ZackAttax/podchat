class PodcastsController < ApplicationController
  def index
  end

  def show
    @podcast = SpotifyApi.find_show(params[:id])
    @episodes = @podcast.episodes(limit: 20, offset: 0, market: "US")
  end

  def search
    @podcasts = SpotifyApi.search_shows(params[:query]) if params[:query].present?
  end
end
