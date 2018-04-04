module Mumukit::Flow
  module Suggestion
    module None
      def self.item
        nil
      end
    end

    class Some
      attr_reader :item
      def initialize(item)
        @item = item
      end
    end

    class Reforce < Some
    end

    class FastForward < Some
    end

    class Retry < Some
    end
  end
end
