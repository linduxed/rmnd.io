require "active_support"
require "active_support/core_ext"
require "nar/date_guess"
require "nar/pm"
require "nar/time_of_day"

module Nar
  class TimeGuess
    def self.time(*args)
      new(*args).time
    end

    def initialize(date_guess: DateGuess.new, tod: TimeOfDay.new(12, 0, 0, Pm.new))
      @date_guess = date_guess
      @tod = tod
    end

    def time(now)
      d = date(now)
      t = Time.new(
        d.year,
        d.month,
        d.day,
        tod.hour,
        tod.minute,
        tod.second,
        tod.time_zone_offset || now.utc_offset,
      )
      if date_guess.ambiguous? && d == now.to_date && t <= now
        if tod.ambiguous? && t.hour.between?(1, 12)
          t + 12.hours
        else
          t + 1.day
        end
      else
        t
      end
    end

    private

    attr_reader :date_guess, :tod

    def date(now)
      date_guess.date(now.to_date)
    end
  end
end
