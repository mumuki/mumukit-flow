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

    include Mumukit::Flow::Node
    include Mumukit::Flow::FlowableAssignment::Closing
    include Mumukit::Flow::FlowableAssignment::Difficulty
    include Mumukit::Flow::FlowableAssignment::Suggesting

    required :item
    required :submissions_count
    required :children
    required :submitter
    required :parent

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

    def first_hard_assignment
      siblings.find &:hard?
    end

    def end_reached?
      next_item.nil?
    end

    def hard_assignments?
      siblings.any? &:hard?
    end

    def children_passed_assignments
      children.select { |assignment| assignment.passed? }
    end

    def item_similar_to?(item)
      (self.item.tags - item.tags).empty?
    end

    def item_has?(tag)
      item.tags.include?(tag)
    end

    private

    # Overridable for better performance
    def pending_sibling_items
      # a cada item hijo pedirle su assignment y quedarse con los que no tienen o lo tinen en pending
      item_assignments = siblings.map { |it| [it.item, it] }.to_h
      sibling_items.reject { |it| item_assignments[it]&.finished?  }
    end
  end
end
