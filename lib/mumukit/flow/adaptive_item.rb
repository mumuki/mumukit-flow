module Mumukit::Flow
  module AdaptiveItem
    include Mumukit::Flow::Suggesting

    required :assignment
    required :structural_children
    required :structural_parent
    required :tags

    delegate :solved?, :submitter, to: :@assignment

    def tagged_as?(tag)
      tags.include? tag
    end

    def no_tags?
      tags.empty?
    end

    def should_skip_next_item?
      similar_easy_siblings_for_every_tag? if next_item&.skippable?
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
      solved_items = solved_siblings_by(submitter).map(&:item)
      structural_parent.structural_children - solved_items
    end

    def first_pending_sibling
      sorted_pending_siblings.first
    end

    def pending_siblings?
      pending_siblings.present?
    end

    def solved_siblings_by(submitter)
      structural_parent.exercise_assignments_for(submitter).compact.select(&:solved?)
    end

    def similar_easy_siblings_for_every_tag?
      next_item.tags.all? { |tag| easy_tag?(tag) } unless next_item.no_tags?
    end

    def easy_tag?(tag)
      easy_siblings_with(tag).count >= min_easy_siblings_for_skipping
    end

    def easy_siblings_with(tag)
      solved_siblings_by(submitter).select { |sibling| sibling.easy? && sibling.item.tagged_as?(tag) }
    end

    def min_easy_siblings_for_skipping
      2
    end
  end
end
