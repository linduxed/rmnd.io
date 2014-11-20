require "active_support"
require "active_support/core_ext"
require "nar/meridies"
require "nar/time_factory"
require "nar/time_of_day"
require "nar/date_factories"
require "nar/time_zones"
require "parslet"

module Nar
  class Transform < Parslet::Transform
    rule integer: simple(:string) do
      string.to_i
    end

    rule january: simple(:january) do
      1
    end

    rule february: simple(:january) do
      2
    end

    rule march: simple(:march) do
      3
    end

    rule april: simple(:april) do
      4
    end

    rule may: simple(:may) do
      5
    end

    rule june: simple(:june) do
      6
    end

    rule july: simple(:july) do
      7
    end

    rule august: simple(:august) do
      8
    end

    rule september: simple(:september) do
      9
    end

    rule october: simple(:october) do
      10
    end

    rule november: simple(:november) do
      11
    end

    rule december: simple(:december) do
      12
    end

    rule tomorrow: simple(:tomorrow) do
      DateFactories::Tomorrow.new
    end

    rule month: simple(:month), day: simple(:day) do
      DateFactories::MonthDay.new(month, day)
    end

    rule month: simple(:month), day: simple(:day), year: simple(:year) do
      DateFactories::Unambiguous.new(year, month, day)
    end

    rule am: simple(:am) do
      Meridies::Am
    end

    rule pm: simple(:am) do
      Meridies::Pm
    end

    rule time_of_day_components: subtree(:time_of_day_components) do
      TimeOfDay.new(time_of_day_components)
    end

    rule utc: simple(:utc) do
      TimeZones::UTC
    end

    rule time_components: subtree(:time_components) do
      TimeFactory.new(time_components)
    end
  end
end
