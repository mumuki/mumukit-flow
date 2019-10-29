module Mumukit::Flow
  module FlowableAssignment
  end
end

require_relative './flowable_assignment/closing'
require_relative './flowable_assignment/terminal'
require_relative './flowable_assignment/suggesting'

module Mumukit::Flow
  module FlowableAssignment
    extend ActiveSupport::Concern

    include Mumukit::Flow::FlowableAssignment::Closing
    include Mumukit::Flow::FlowableAssignment::Difficulty
    include Mumukit::Flow::FlowableAssignment::Suggesting

    required :submissions_count
    required :submitter

    def next_item_suggestion_type
      difficulty.next_item_suggestion_type
    end

  end
end
