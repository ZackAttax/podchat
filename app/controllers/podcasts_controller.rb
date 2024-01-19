class PodcastsController < ApplicationController
  before_action :authenticate_user!
  before_action :add_search_to_breadcrumb

  def index
  end

  def show
    @podcast = SpotifyApi.find_show(params[:id])
    add_breadcrumb @podcast.name, podcasts_show_url(@podcast.id)
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
