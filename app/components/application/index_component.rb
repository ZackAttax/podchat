# frozen_string_literal: true

class Application::IndexComponent < ViewComponent::Base
  def initialize(title: "hello")
    @title = title
  end

end
