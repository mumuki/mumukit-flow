module Mumukit::Flow
  module AdaptiveAssignment

    required :passed?

    def easy?
      passed? && submissions_count <= 3
    end

    def hard?
      submissions_count >= 10
    end
  end
end
