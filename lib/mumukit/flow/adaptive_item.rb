module Mumukit::Flow
  module AdaptiveItem
    include Mumukit::Flow::Node
    include Mumukit::Flow::Suggesting

    required :assignment
    required :children
    required :parent
    required :tags

    delegate :passed?, :submitter, to: :@assignment

    def tagged_as?(tag)
      tags.include? tag
    end

    def should_skip_next_item?
      similar_easy_siblings_for_every_tag? if next_item.skippable?
    end

    def skippable?
      practice?
    end

    def end_reached?
      next_item.nil?
    end

    private

    def set_adaptive_assignment!(submitter)
      @assignment = assignment_for submitter
      @assignment.skip_if_pending!
    end

    def next_item
      @next_item ||= next_items.first
    end

    def next_items
      sorted_pending_siblings.select { |it| it.number > number }
    end

    def sorted_pending_siblings
      pending_siblings.sort_by(&:number)
    end

    def pending_siblings
      passed_items = passed_siblings_by(submitter).map(&:item)
      parent.children - passed_items
    end

    def first_pending_sibling
      sorted_pending_siblings.first
    end

    def pending_siblings?
      pending_siblings.present?
    end

    def passed_siblings_by(submitter)
      parent.exercise_assignments_for(submitter).select(&:passed?)
    end

    def similar_easy_siblings_for_every_tag?
      next_item.tags.all? { |tag| easy_siblings_with(tag).count >= 2 }
    end

    def easy_siblings_with(tag)
      passed_siblings_by(submitter).select { |sibling| sibling.easy? && sibling.item.tagged_as?(tag) }
    end
  end
end
