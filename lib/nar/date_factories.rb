module Nar
  module DateFactories
    class Unambiguous
      def initialize(year, month, day)
        @year = year
        @month = month
        @day = day
      end

      def new(_)
        Date.new(year, month, day)
      end

      def ambiguous?
        false
      end

      private

      attr_reader :year, :month, :day
    end

    class Ambiguous
      def new
        raise NotImplementedError
      end

      def ambiguous?
        true
      end
    end

    class Today < Ambiguous
      def new(current)
        current
      end
    end

    class Tomorrow < Ambiguous
      def new(current)
        current.tomorrow
      end
    end

    class MonthDay < Ambiguous
      def initialize(month, day)
        @month = month
        @day = day
      end

      def new(current)
        advance(Date.new(current.year, month, day), current)
      end

      private

      attr_reader :month, :day

      def advance(date, current)
        if date <= current
          date.advance(years: 1)
        else
          date
        end
      end
    end
  end
end
