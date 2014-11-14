require "active_support"
require "active_support/core_ext"

module Nar
  class DateGuess
    def initialize(year: nil, month: nil, day: nil)
      @year = year
      @month = month
      @day = day
    end

    def date(current)
      case unambiguous
      when %i(year month day)
        Date.new(year, month, day)
      when %i(year month)
        Date.new(year, month, 1)
      when %i(year day)
        Date.new(year, 1, day)
      when %i(month day)
        advance(:years, Date.new(current.year, month, day), current)
      when %i(year)
        Date.new(year, 1, 1)
      when %i(month)
        advance(:years, Date.new(current.year, month, 1), current)
      when %i(day)
        advance(:months, Date.new(current.year, current.month, day), current)
      else
        current
      end
    end

    def ambiguous?
      unambiguous != %i(year month day)
    end

    private

    def unambiguous
      %i(year month day).select { |data| send(data).present? }
    end

    def advance(unit, date, current)
      if date <= current
        date.advance(unit => 1)
      else
        date
      end
    end

    attr_reader :year, :month, :day
  end
end
