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
      at_least_two_similar_easy_assignments?
    end

    def at_least_two_similar_easy_assignments?
      assignments = similar_solved_assignments
      assignments.count >= 2 && (solved_most_easily? assignments)
    end

    def similar_solved_assignments
      solved_sibling_items.select { |item| has_all? item.item.tags, next_item.tags }
    end

    def has_all?(tags, other_tags)
      (tags - other_tags).empty?
    end

    def solved_most_easily?(items)
      items.count { |item| item.easy? } > items.count / 2
    end

    def next_learning_item
      next_items.find { |it| it.learning? } || next_item
    end

    def next_practice_item
      next_items.find { |it| it.practice? } || next_item
    end
  end
end
