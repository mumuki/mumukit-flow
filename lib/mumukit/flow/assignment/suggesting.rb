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
        if next_item_suggestion_type == :learning
          Mumukit::Flow::Suggestion::Skip.new(next_learning_item)
        else
          Mumukit::Flow::Suggestion::Continue.new(next_practice_item)
        end
      end
    end

    private

    def next_learning_item
      next_items.find { |it| it.learning? } || next_item
    end

    def next_practice_item
      next_items.find { |it| it.practice? } || next_item
    end
  end
end
