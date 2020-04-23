module Mumukit::Flow
  module AdaptiveAssignment

    required :solved?

    def easy?
      solved? && submissions_count <= max_submissions_for_easy
    end

    def hard?
      submissions_count >= min_submissions_for_hard
    end

    def max_submissions_for_easy
      3
    end

    def min_submissions_for_hard
      10
    end
  end
end
