# frozen_string_literal: true

class ReplyComponent < ViewComponent::Base
  def initialize(reply:)
    @reply = reply
  end

end
