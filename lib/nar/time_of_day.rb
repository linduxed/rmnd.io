require "nar/unspecified_meridiem"

module Nar
  class TimeOfDay
    attr_reader :minute, :second, :time_zone

    def initialize(hour, minute, second, meridiem = nil, time_zone = nil)
      @hour = hour
      @minute = minute
      @second = second
      @meridiem = meridiem || UnspecifiedMeridiem.new
      @time_zone = time_zone
    end

    def hour
      meridiem.to_twentyfour(@hour)
    end

    def ambiguous?
      meridiem.unspecified?
    end

    def time_zone_offset
      time_zone.try(:offset)
    end

    private

    attr_reader :meridiem
  end
end
