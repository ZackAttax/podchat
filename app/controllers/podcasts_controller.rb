class PodcastsController < ApplicationController
  def index
  end

  def show
    @podcast = SpotifyApi.find_show(params[:id])
    @pagy, @episodes = pagy_custom_episode(@podcast)
  end

  def search
    @query = params[:query] || ""
    @pagy, @podcasts = pagy_custom_show(params[:query]) if params[:query].present?
  end

  private

  def pagy_custom_show(query)
    pagy = Pagy.new(count: SpotifyApi.search_shows(query).total, page: params[:page])
    [pagy, SpotifyApi.search_shows(query, pagy.offset, pagy.items)]
  end

  def pagy_custom_episode(podcast)
    pagy = Pagy.new(count:SpotifyApi.show_total_episodes(podcast.id), page: params[:page])
    [pagy, podcast.episodes(offset: pagy.offset, limit: pagy.items, market: "US")]
  end

end
