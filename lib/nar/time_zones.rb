module Nar
  module TimeZones
    class Current
      def initialize(now)
        @now = now
      end

      def offset
        now.utc_offset
      end

      private

      attr_reader :now
    end

    class UTC
      def initialize(_)
      end

      def offset
        0
      end
    end
  end
end
