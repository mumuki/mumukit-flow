module Mumukit::Flow
  module Suggesting
    def next_suggested_item
      next_item_suggestion.item
    end

    def next_item_suggestion
      raise 'can not suggest until closed' unless assignment.closed?

      if end_reached?
        if pending_items?
          Mumukit::Flow::Suggestion::Revisit.new(first_pending_item)
        else
          Mumukit::Flow::Suggestion::None
        end
      else
        if should_skip_next_item?
          Mumukit::Flow::Suggestion::Skip.new(next_item)
        else
          Mumukit::Flow::Suggestion::Continue.new(next_item)
        end
      end
    end

    private

    def should_skip_next_item?
      similar_easy_assignments_for_every_tag? unless next_item.learning?
    end

    def similar_easy_assignments_for_every_tag?
      next_item.tags.all? { |tag| easy_assignments_with(tag).count >= 2 }
    end

    def easy_assignments_with(tag)
      parent_passed_assignments.select { |assignment| assignment.easy? && assignment.item_has?(tag) }
    end

    def parent_passed_assignments
      parent.children_passed_assignments
    end

    def passed_most_easily?(assignments)
      assignments.count { |assignment| assignment.easy? } > assignments.count / 2
    end
  end
end
