module Mumukit::Flow
  module AdaptiveItem
    include Mumukit::Flow::Node
    include Mumukit::Flow::Suggesting

    required :assignment
    required :children
    required :parent

    delegate :closed?, :passed?, :submitter, to: :assignment

    attr_reader :assignment

    def set_adaptive_assignment!(submitter)
      @assignment = assignment_for submitter
      assignment.skip_if_pending!
    end

    def level
      if has_children?
        average_submissions_count
      else
        submissions_count
      end
    end

    def average_submissions_count
      assignment.submissions_count / children.size
    end

    def has_children?
      children.present?
    end

    def next_item
      next_items.first
    end

    def next_items
      sorted_pending_sibling_items.select { |it| it.number > number }
    end

    def sibling_items
      item.siblings
    end

    def first_pending_item
      sorted_pending_sibling_items.first
    end

    def sorted_pending_sibling_items
      pending_siblings.sort_by(&:number)
    end

    def pending_items?
      pending_siblings.present?
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

    def pending_siblings
      siblings.reject { |sibling| sibling.finished? }
    end

  end
end

