class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :add_home_breadcrumb

  def index
   add_breadcrumb "Home", root_path
  end

  private

  def add_home_breadcrumb
    add_breadcrumb "Home", root_path
  end
end
