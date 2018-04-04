module Mumukit::Flow
  class Difficulty
    attr_reader :level

    def initialize(level = 0)
      @level = level
    end

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
