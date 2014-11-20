require "active_support"
require "active_support/core_ext"
require "nar/date_factories"
require "nar/time_of_day"
require "nar/time_zones"

module Nar
  class TimeFactory
    def initialize(
      date_factory: DateFactories::Today.new,
      time_of_day: TimeOfDay.new,
      time_zone: TimeZones::Current
    )
      @date_factory = date_factory
      @time_of_day = time_of_day
      @time_zone = time_zone
    end

    def time(now)
      advance(base_time(now), now)
    end

    private

    delegate :hour, :minute, :second, to: :time_of_day

    def base_time(now)
      Time.new(
        year(now),
        month(now),
        day(now),
        hour,
        minute,
        second,
        offset(now),
      )
    end

    def year(now)
      date(now).year
    end

    def month(now)
      date(now).month
    end

    def day(now)
      date(now).day
    end

    def date(now)
      date_factory.new(now.to_date)
    end

    def offset(now)
      time_zone.new(now).offset
    end

    def advance(time, now)
      if past?(time, now)
        time + distance
      else
        time
      end
    end

    def past?(time, now)
      date_factory.ambiguous? &&
        time.to_date == now.to_date &&
        time <= now
    end

    def distance
      if time_of_day.ambiguous? && hour.between?(1, 11)
        12.hours
      else
        1.day
      end
    end

    attr_reader :date_factory, :time_of_day, :time_zone
  end
end
