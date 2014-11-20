
module Nar
  module Meridies
    class Meridiem
      def initialize(hour)
        @hour = hour
      end

      def unspecified?
        raise NotImplementedError
      end

      private

      attr_reader :hour
    end

    class Am < Meridiem
      def hour
        if super == 12
          0
        else
          super
        end
      end

      def unspecified?
        false
      end
    end

    class Pm < Meridiem
      def hour
        if super < 12
          super + 12
        else
          super
        end
      end

      def unspecified?
        false
      end
    end

    class Unspecified < Meridiem
      def hour
        super
      end

      def unspecified?
        true
      end
    end
  end
end
