module Mumukit::Flow
  module AdaptiveItem
    include Mumukit::Flow::Node
    include Mumukit::Flow::Suggesting

    required :assignment
    required :children
    required :parent

    delegate :passed?, :submitter, to: :assignment

    attr_reader :assignment

    def set_adaptive_assignment!(submitter)
      @assignment = assignment_for submitter
      assignment.skip_if_pending!
    end

    def end_reached?
      next_item.nil?
    end

    def next_item
      next_items.first
    end

    def next_items
      sorted_pending_sibling_items.select { |it| it.number > number }
    end

    def sorted_pending_sibling_items
      pending_siblings.sort_by(&:number)
    end

    def pending_siblings
      siblings.reject { |sibling| sibling.passed? }
    end

    def first_pending_item
      sorted_pending_sibling_items.first
    end

    def pending_items?
      pending_siblings.present?
    end

    def children_passed_assignments_by(submitter)
      exercise_assignments_for(submitter).select { |assignment| assignment.passed? }
    end

    def has?(tag)
      tags.include?(tag)
    end
  end
end
