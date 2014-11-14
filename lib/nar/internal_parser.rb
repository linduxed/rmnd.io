require "parslet"

module Nar
  class InternalParser < Parslet::Parser
    root(:time)
    rule(:time) {
      date.as(:date) >> tod.as(:tod) |
      date.as(:date) |
      tod.as(:tod) >> date.as(:date) |
      tod.as(:tod)
    }

    rule(:date) {
      spaces? >> tomorrow |
      dprefix >> (
        mnum.as(:month) >> dsep >> day.as(:day) >> (dsep >> year.as(:year)).maybe |
        mname.as(:month) >> spaces? >> day.as(:day) >> (spaces >> year.as(:year)).maybe |
        (year.as(:year) >> dsep).maybe >> mnum.as(:month) >> dsep >> day.as(:day) |
        (year.as(:year) >> spaces).maybe >> mname.as(:month) >> spaces? >> day.as(:day) |
        day.as(:day) >> dsep >> mnum.as(:month) >> (dsep >> year.as(:year)).maybe |
        day.as(:day) >> spaces? >> mname.as(:month) >> (spaces >> year.as(:year)).maybe |
        (year.as(:year) >> dsep).maybe >> day.as(:day) >> dsep >> mnum.as(:month) |
        (year.as(:year) >> spaces).maybe >> day.as(:day) >> spaces? >> mname.as(:month)
      )
    }
    rule(:tomorrow) { str("tomorrow").as(:tomorrow) }
    rule(:dprefix) { spaces? >> on? >> spaces? }
    rule(:on?) { on.maybe }
    rule(:on) { str("on") >> spaces? }
    rule(:mname) { lmname | smname }
    rule(:smname) { (stri("Jan") | stri("Feb") | stri("Mar") | stri("Apr") | stri("May") | stri("Jun") | stri("Jul") | stri("Aug") | stri("Sep") | stri("Oct") | stri("Nov") | stri("Dec")).as(:smname) }
    rule(:lmname) { (stri("January") | stri("February") | stri("March") | stri("April") | stri("May") | stri("June") | stri("July") | stri("August") | stri("September") | stri("October") | stri("November") | stri("December")).as(:lmname) }
    rule(:mnum) { (str("1") >> match("[0-2]") | str("0").maybe >> match("[1-9]")).as(:integer) }
    rule(:dsep) { slash | dash }
    rule(:slash) { str("/") }
    rule(:dash) { str("-") }
    rule(:day) { (str("3") >> match("[0-1]") | match("[1-2]") >> match("[0-9]") | str("0").maybe >> match("[1-9]")).as(:integer) }
    rule(:year) { (match("[0-9]").repeat(4)).as(:integer) }

    rule(:tod) { tprefix >> hour.as(:hour) >> tsep? >> minute?.as(:minute) >> tsep? >> second?.as(:second) >> spaces? >> meridiem?.as(:meridiem) >> time_zone?.as(:time_zone) }
    rule(:tprefix) { str("T") | spaces? >> at? >> spaces? }
    rule(:spaces?) { spaces.maybe }
    rule(:spaces) { str(" ").repeat(1) }
    rule(:at?) { at.maybe }
    rule(:at) { str("at") | str("@") }
    rule(:hour) { (str("2") >> match("[0-4]") | match("[0-1]").maybe >> match("[0-9]") | match("[0-9]")).as(:integer) }
    rule(:tsep?) { tsep.maybe }
    rule(:tsep) { colon | period }
    rule(:colon) { str(":") }
    rule(:period) { str(".") }
    rule(:minute?) { minute.maybe }
    rule(:minute) { (match("[0-5]").maybe >> match("[0-9]") | match("[0-9]")).as(:integer) }
    rule(:second?) { second.maybe }
    rule(:second) { (match("[0-5]").maybe >> match("[0-9]") | match("[0-9]")).as(:integer) }
    rule(:meridiem?) { meridiem.maybe }
    rule(:meridiem) { am.as(:am) | pm.as(:pm) }
    rule(:am) { str("am") }
    rule(:pm) { str("pm") }
    rule(:time_zone?) { time_zone.maybe }
    rule(:time_zone) { utc }
    rule(:utc) { str("Z").as(:utc) }

    def stri(str)
      str.split(//).
        collect! { |char| match("[#{char.upcase}#{char.downcase}]") }.
        reduce(:>>)
    end
  end
end
