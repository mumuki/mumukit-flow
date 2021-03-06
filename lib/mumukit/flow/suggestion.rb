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

    class Continue < Some
    end

    class Skip < Some
    end

    class Reinforce < Some
    end

    class Revisit < Some
    end
  end
end
