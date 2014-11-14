require "active_support"
require "active_support/core_ext"
require "nar/am"
require "nar/date_guess"
require "nar/pm"
require "nar/time_guess"
require "nar/time_of_day"
require "nar/tomorrow"
require "nar/time_zones"
require "parslet"

module Nar
  class Transform < Parslet::Transform
    rule(integer: simple(:x)) { x.to_i }
    rule(am: simple(:_)) { Am.new }
    rule(pm: simple(:_)) { Pm.new }
    rule(lmname: simple(:lmname)) { |c| long_month_names.fetch(c[:lmname].to_s.downcase) }
    rule(smname: simple(:smname)) { |c| short_month_names.fetch(c[:smname].to_s.downcase) }
    rule(tomorrow: simple(:_)) { Tomorrow.new }
    rule(utc: simple(:_)) { TimeZones::UTC.new }
    rule(
      month: simple(:month),
      day: simple(:day),
    ) { DateGuess.new(month: month, day: day) }
    rule(
      month: simple(:month),
      day: simple(:day),
      year: simple(:year),
    ) { DateGuess.new(year: year, month: month, day: day) }
    rule(
      hour: simple(:hour),
      minute: simple(:minute),
      second: simple(:second),
      meridiem: simple(:meridiem),
      time_zone: simple(:time_zone),
    ) { TimeOfDay.new(hour, minute, second, meridiem, time_zone) }
    rule(tod: simple(:tod)) { TimeGuess.new(tod: tod) }
    rule(date: simple(:date_guess)) { TimeGuess.new(date_guess: date_guess) }
    rule(
      date: simple(:date_guess),
      tod: simple(:tod),
    ) { TimeGuess.new(date_guess: date_guess, tod: tod) }

    def self.long_month_names
      {
        "january" => 1,
        "february" => 2,
        "march" => 3,
        "april" => 4,
        "may" => 5,
        "june" => 6,
        "july" => 7,
        "august" => 8,
        "september" => 9,
        "october" => 10,
        "november" => 11,
        "december" => 12,
      }
    end

    def self.short_month_names
      {
        "jan" => 1,
        "feb" => 2,
        "mar" => 3,
        "apr" => 4,
        "may" => 5,
        "jun" => 6,
        "jul" => 7,
        "aug" => 8,
        "sep" => 9,
        "oct" => 10,
        "nov" => 11,
        "dec" => 12,
      }
    end

    def tomorrow
      Date.tomorrow
    end
  end
end
