require "parslet"

module Nar
  class InternalParser < Parslet::Parser
    root :time_components

    rule :time_components do
      (date_and_or_time_of_day >> time_zone?).as(:time_components)
    end

    rule :date_and_or_time_of_day do
      on? >> date >> at? >> time_of_day.maybe |
        at? >> time_of_day >> on? >> date.maybe
    end

    rule :date do
      (tomorrow | numerical_date | date_with_month_name).as(:date_factory)
    end

    rule :on? do
      spaces? >> str("on").maybe >> spaces?
    end

    rule :tomorrow do
      str("tomorrow").as(:tomorrow)
    end

    rule :numerical_date do
      numerical_month_day >> (date_separator >> year).maybe |
        (year >> date_separator).maybe >> numerical_month_day
    end

    rule :numerical_month_day do
      month_number >> date_separator >> day |
        day >> date_separator >> month_number
    end

    rule :date_with_month_name do
      named_month_day >> (spaces >> year).maybe |
        (year >> spaces).maybe >> named_month_day
    end

    rule :named_month_day do
      month_name >> spaces? >> day | day >> spaces? >> month_name
    end

    rule :month_name do
      (january | february | march | april | may | june | july | august |
       september | october | november | december).as(:month)
    end

    rule :january do
      (stri("January") | stri("Jan")).as(:january)
    end

    rule :february do
      (stri("February") | stri("Feb")).as(:february)
    end

    rule :march do
      (stri("March") | stri("Mar")).as(:march)
    end

    rule :april do
      (stri("April") | stri("Apr")).as(:april)
    end

    rule :may do
      stri("May").as(:may)
    end

    rule :june do
      (stri("June") | stri("Jun")).as(:june)
    end

    rule :july do
      (stri("July") | stri("Jul")).as(:july)
    end

    rule :august do
      (stri("August") | stri("Aug")).as(:august)
    end

    rule :september do
      (stri("September") | stri("Sep")).as(:september)
    end

    rule :october do
      (stri("October") | stri("Oct")).as(:october)
    end

    rule :november do
      (stri("November") | stri("Nov")).as(:november)
    end

    rule :december do
      (stri("December") | stri("Dec")).as(:december)
    end

    rule :month_number do
      one_to_twelve.as(:month)
    end

    rule :one_to_twelve do
      (str("1") >> match("[0-2]") |
       str("0").maybe >> match("[1-9]")).as(:integer)
    end

    rule :date_separator do
      match("[/\-]")
    end

    rule :day do
      one_to_thirty.as(:day)
    end

    rule :one_to_thirty do
      (str("3") >> match("[0-1]") |
       match("[1-2]") >> digit |
       str("0").maybe >> match("[1-9]")).as(:integer)
    end

    rule :year do
      digit.repeat(4).as(:integer).as(:year)
    end

    rule :digit do
      match("[0-9]")
    end

    rule :time_of_day do
      time_of_day_components.as(:time_of_day)
    end

    rule :time_of_day_components do
      (hour >>
       time_separator? >> minute? >>
       time_separator? >> second? >>
       spaces? >> meridiem?).as(:time_of_day_components)
    end

    rule :at? do
      str("T") | spaces? >> (str("at") | str("@")).maybe >> spaces?
    end

    rule :hour do
      zero_to_twentyfour.as(:hour)
    end

    rule :zero_to_twentyfour do
      (str("2") >> match("[0-4]") |
       match("[0-1]").maybe >> digit |
       digit).as(:integer)
    end

    rule :time_separator? do
      match("[:.]").maybe
    end

    rule :minute? do
      zero_to_fiftynine.as(:minute).maybe
    end

    rule :second? do
      zero_to_fiftynine.as(:second).maybe
    end

    rule :zero_to_fiftynine do
      (match("[0-5]").maybe >> digit | digit).as(:integer)
    end

    rule :meridiem? do
      (am | pm).as(:meridiem_factory).maybe
    end

    rule :am do
      str("am").as(:am)
    end

    rule :pm do
      str("pm").as(:pm)
    end

    rule :time_zone? do
      (utc).as(:time_zone).maybe
    end

    rule :utc do
      str("Z").as(:utc)
    end

    rule :spaces? do
      spaces.maybe
    end

    rule :spaces do
      str(" ").repeat(1)
    end

    def stri(string)
      string.
        split(//).
        map! { |char| match("[#{char.upcase}#{char.downcase}]") }.
        reduce(:>>)
    end
  end
end
