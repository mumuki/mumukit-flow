module Mumukit::Flow::Assignment
  module Suggesting
    def next_suggested_item
      next_item_suggestion.item
    end

    def next_item_suggestion
      raise 'can not suggest until closed' unless closed?

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
      at_least_two_similar_easy_assignments? unless next_item.learning?
    end

    def at_least_two_similar_easy_assignments?
      assignments = similar_solved_assignments
      assignments.count >= 2 && (solved_most_easily? assignments)
    end

    def similar_solved_assignments
      parent.children_passed_assignments.select { |assignment| assignment.item_similar_to?(next_item) }
    end

    def solved_most_easily?(assignments)
      assignments.count { |assignment| assignment.easy? } > assignments.count / 2
    end
  end
end
