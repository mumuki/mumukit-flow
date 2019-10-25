module Mumukit::Flow::AdaptiveAssignment
  module Closing

    # Can be called whenever you think the exercise may have being finished
    def try_close!
      close! if finished?
    end

    # Must be called when you know that the exercise has been finished
    def close!
      close_self!
      close_parent!
    end

    # Answers if this assignment and all its subtasks
    # have being completed
    def finished?
      closed? || children.all?(&:finished?)
    end

    def reopen!
      reopen_self!
      reopen_parent!
    end

    private

    def reopen_self!
      self.closed = false
    end

    def reopen_parent!
      parent.reopen! if parent&.closed?
    end

    def close_self!
      self.closed = true
      self.submissions_count = children.map { |it| it.submissions_count }.sum
    end

    def close_parent!
      parent.close! if parent&.finished?
    end
  end
end
