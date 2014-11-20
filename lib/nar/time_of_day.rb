require "nar/meridies"

module Nar
  class TimeOfDay
    attr_reader :minute, :second

    delegate :hour, to: :meridiem

    def initialize(
      hour: 12,
      minute: 0,
      second: 0,
      meridiem_factory: Meridies::Unspecified
    )
      @minute = minute
      @second = second
      @meridiem = meridiem_factory.new(hour)
    end

    def ambiguous?
      meridiem.unspecified?
    end

    private

    attr_reader :meridiem
  end
end
