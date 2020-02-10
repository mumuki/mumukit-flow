module Mumukit::Flow
  module Suggesting
    def next_suggested_item_for(submitter)
      set_adaptive_assignment!(submitter)
      next_item_suggestion(submitter).item
    end

    private

    def next_item_suggestion(submitter)
      if end_reached?
        if pending_siblings?
          Mumukit::Flow::Suggestion::Revisit.new(first_pending_sibling)
        else
          Mumukit::Flow::Suggestion::None
        end
      elsif should_skip_next_item?
        Mumukit::Flow::Suggestion::Skip.new(next_item.next_suggested_item_for(submitter))
      else
        Mumukit::Flow::Suggestion::Continue.new(next_item)
      end
    end
  end
end
