module Mumukit::Flow::FlowableAssignment
  module Terminal
    include Mumukit::Flow::FlowableAssignment

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
