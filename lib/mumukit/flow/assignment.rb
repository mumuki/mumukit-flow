module Mumukit::Flow
  module Assignment
    module Helpers
      extend ActiveSupport::Concern

      include Mumukit::Flow::Node

      # must provide:
      #  * item
      #  * submissions_count
      #  * children
      #  * submitter
      #  * parent

      delegate :easy?,
               :hard?,
               :should_retry?, to: :difficulty

      def difficulty
        Mumukit::Flow::Difficulty.new(level)
      end

      def level
        if has_children?
          average_submissions_count
        else
          submissions_count
        end
      end

      def has_children?
        children.present?
      end

      def average_submissions_count
        submissions_count / children.size
      end

      # Must be called when you know that the exercise has been finished
      def close!
        parent.close! if parent.finished?
      end

      # Overridable for better performance
      def next_item
        next_items.first
      end

      # Overridable for better performance
      def next_items
        sorted_pending_sibling_items.select { |it| it.number > item.number }
      end

      def sibling_items
        item.siblings
      end

      def first_pending_item
        sorted_pending_sibling_items.first
      end

      def sorted_pending_sibling_items
        pending_sibling_items.sort_by(&:number)
      end

      def pending_items?
        pending_sibling_items.present?
      end

      def next_item_suggestion_type
        difficulty.next_item_suggestion_type
      end

      def next_item_suggestion
        if next_item.nil?
          if pending_items?
            Mumukit::Flow::Suggestion::Revisit.new(first_pending_item)
          else
            Mumukit::Flow::Suggestion::None
          end
        else
          if next_item_suggestion_type == :learning
            Mumukit::Flow::Suggestion::FastForward.new(next_learning_item)
          else
            Mumukit::Flow::Suggestion::Continue.new(next_practice_item)
          end
        end
      end

      private

      # Overridable for better performance
      def pending_sibling_items
        # a cada item hijo pedirle su assignment y quedarse con los que no tienen o lo tinen en pending
        item_assignments = siblings.map { |it| [it.item, it] }.to_h
        sibling_items.reject { |it| item_assignments[it]&.finished?  }
      end

      def next_learning_item
        next_items.select { |it| it.learning? }.first || next_item
      end

      def next_practice_item
        next_items.select { |it| it.practice? }.first || next_item
      end
    end
  end
end
