# frozen_string_literal: true

class CommentComponent < ViewComponent::Base
  def initialize(comment:)
    @comment = comment
    # @current_user = current_user
  end

end
