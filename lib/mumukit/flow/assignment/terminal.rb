module Mumukit::Flow::Assignment
  module Terminal
    include Mumukit::Flow::Assignment

    def children
      []
    end

    def finished?
      passed?
    end

    def closed?
      finished?
    end

    def close_self!
    end

    def reopen_self!
    end
  end
end
