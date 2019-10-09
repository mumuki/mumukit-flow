module Mumukit::Flow::Assignment
  module Difficulty
    def easy?
      level <= 3
    end

    def hard?
      level >= 10
    end

    def should_retry?
      hard?
    end

    def next_item_suggestion_type
      easy? ? :learning : :practice
    end
  end
end
