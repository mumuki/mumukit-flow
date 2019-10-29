module Mumukit::Flow
  module AdaptiveAssignment
  end
end

require_relative './adaptive_assignment/closing'
require_relative './adaptive_assignment/terminal'
require_relative './adaptive_assignment/suggesting'

module Mumukit::Flow
  module AdaptiveAssignment
    extend ActiveSupport::Concern

    include Mumukit::Flow::AdaptiveAssignment::Closing
    include Mumukit::Flow::AdaptiveAssignment::Difficulty
    include Mumukit::Flow::AdaptiveAssignment::Suggesting

    required :submissions_count
    required :submitter

    def next_item_suggestion_type
      difficulty.next_item_suggestion_type
    end

  end
end
