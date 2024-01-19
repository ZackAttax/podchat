class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :add_home_breadcrumb

  def index; end

  private

  def add_home_breadcrumb
    add_breadcrumb "Home", root_path
  end

  def add_search_to_breadcrumb
    add_breadcrumb "Search", podcasts_search_path
  end
end
