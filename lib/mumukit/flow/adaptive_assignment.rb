module Mumukit::Flow
  module AdaptiveAssignment
  end
end

require_relative './adaptive_assignment/closing'
require_relative './adaptive_assignment/terminal'

module Mumukit::Flow
  module AdaptiveAssignment
    extend ActiveSupport::Concern

    include Mumukit::Flow::AdaptiveAssignment::Closing
    include Mumukit::Flow::AdaptiveAssignment::Difficulty

    def next_item_suggestion_type
      difficulty.next_item_suggestion_type
    end

  end
end
