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
      sorted_pending_siblings.select { |it| it.number > number }
    end

    def sorted_pending_siblings
      pending_siblings.sort_by(&:number)
    end

    def pending_siblings
      assignments = parent.exercise_assignments_for(submitter)
      assignments.map { |assignment| assignment.item }.reject { |item| item.passed? }
    end

    def first_pending_sibling
      sorted_pending_siblings.first
    end

    def pending_siblings?
      pending_siblings.present?
    end

    def passed_siblings_by(submitter)
      parent.exercise_assignments_for(submitter).select { |assignment| assignment.passed? }
    end

    def has?(tag)
      tags.include?(tag)
    end
  end
end
