module Mumukit::Flow::AdaptiveAssignment
  module Difficulty
    def easy?
      passed? && submissions_count <= 3
    end

    def hard?
      submissions_count >= 10
    end
  end
end
