class ApplicationController < ActionController::Base
  before_action :add_initial_breadcrumbs
  include Pagy::Backend

  def index
    breadcrumbs.add "Home", root_path
  end
end
