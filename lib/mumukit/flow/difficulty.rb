module Mumukit::Flow::Assignment
  module Difficulty
    def easy?
      closed? && level <= 3
    end

    def hard?
      level >= 10
    end
  end
end
