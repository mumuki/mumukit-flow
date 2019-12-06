module Mumukit::Flow::AdaptiveAssignment
  module Difficulty
    def easy?
      closed? && submissions_count <= 3
    end

    def hard?
      submissions_count >= 10
    end
  end
end
