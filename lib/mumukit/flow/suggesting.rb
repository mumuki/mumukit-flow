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
      else
        if should_skip_next_item?
          Mumukit::Flow::Suggestion::Skip.new(next_item.next_suggested_item_for(submitter))
        else
          Mumukit::Flow::Suggestion::Continue.new(next_item)
        end
      end
    end

    def should_skip_next_item?
      similar_easy_siblings_for_every_tag? unless next_item.learning?
    end

    def similar_easy_siblings_for_every_tag?
      next_item.tags.all? { |tag| easy_siblings_with(tag).count >= 2 }
    end

    def easy_siblings_with(tag)
      passed_siblings_by(self.submitter).select { |sibling| sibling.easy? && sibling.item.tagged_as?(tag) }
    end
  end
end
