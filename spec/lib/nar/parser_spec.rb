require "spec_helper"
require "active_support"
require "active_support/core_ext"
require "active_support/testing/time_helpers"
require "nar/parser"

describe Nar::Parser do
  include ActiveSupport::Testing::TimeHelpers

  describe "#time" do
    context "at 2014-11-14 8:00:00" do
      def now
        Time.new(2014, 11, 14, 8, 0, 0, 0)
      end

      context "when unparseable" do
        it "returns nil" do
          expect(time("this is not a time")).to eq nil
        end
      end

      describe "hours" do
        specify { expect(time("07")).to eq Time.new(2014, 11, 14, 19, 0, 0, 0) }
        specify { expect(time("7")).to eq Time.new(2014, 11, 14, 19, 0, 0, 0) }
        specify { expect(time("7am")).to eq Time.new(2014, 11, 15, 7, 0, 0, 0) }
        specify { expect(time("7pm")).to eq Time.new(2014, 11, 14, 19, 0, 0, 0) }
        specify { expect(time("8")).to eq Time.new(2014, 11, 14, 20, 0, 0, 0) }
        specify { expect(time("8am")).to eq Time.new(2014, 11, 15, 8, 0, 0, 0) }
        specify { expect(time("8pm")).to eq Time.new(2014, 11, 14, 20, 0, 0, 0) }
        specify { expect(time("9")).to eq Time.new(2014, 11, 14, 9, 0, 0, 0) }
        specify { expect(time("9am")).to eq Time.new(2014, 11, 14, 9, 0, 0, 0) }
        specify { expect(time("9pm")).to eq Time.new(2014, 11, 14, 21, 0, 0, 0) }
        specify { expect(time("22")).to eq Time.new(2014, 11, 14, 22, 0, 0, 0) }
        specify { expect(time("22am")).to eq Time.new(2014, 11, 14, 22, 0, 0, 0) }
        specify { expect(time("22pm")).to eq Time.new(2014, 11, 14, 22, 0, 0, 0) }
        specify { expect(time("12")).to eq Time.new(2014, 11, 14, 12, 0, 0, 0) }
        specify { expect(time("12am")).to eq Time.new(2014, 11, 15, 0, 0, 0, 0) }
        specify { expect(time("12pm")).to eq Time.new(2014, 11, 14, 12, 0, 0, 0) }
        specify { expect(time("at 3")).to eq Time.new(2014, 11, 14, 15, 0, 0, 0) }
        specify { expect(time("at 2pm")).to eq Time.new(2014, 11, 14, 14, 0, 0, 0) }
        specify { expect(time("at 22")).to eq Time.new(2014, 11, 14, 22, 0, 0, 0) }
        specify { expect(time("at 04am")).to eq Time.new(2014, 11, 15, 4, 0, 0, 0) }
        specify { expect(time("at 12")).to eq Time.new(2014, 11, 14, 12, 0, 0, 0) }
        specify { expect(time("at 0")).to eq Time.new(2014, 11, 15, 0, 0, 0, 0) }
        specify { expect(time("@ 4")).to eq Time.new(2014, 11, 14, 16, 0, 0, 0) }
        specify { expect(time("@ 5am")).to eq Time.new(2014, 11, 15, 5, 0, 0, 0) }
        specify { expect(time("@ 00")).to eq Time.new(2014, 11, 15, 0, 0, 0, 0) }
        specify { expect(time("@ 23")).to eq Time.new(2014, 11, 14, 23, 0, 0, 0) }
        specify { expect(time("@ 2pm")).to eq Time.new(2014, 11, 14, 14, 0, 0, 0) }
        specify { expect(time("@1 am")).to eq Time.new(2014, 11, 15, 1, 0, 0, 0) }
      end

      describe "hours and minutes" do
        specify { expect(time("7:01")).to eq Time.new(2014, 11, 14, 19, 1, 0, 0) }
        specify { expect(time("7:01am")).to eq Time.new(2014, 11, 15, 7, 1, 0, 0) }
        specify { expect(time("7:01pm")).to eq Time.new(2014, 11, 14, 19, 1, 0, 0) }
        specify { expect(time("8:01")).to eq Time.new(2014, 11, 14, 8, 1, 0, 0) }
        specify { expect(time("8:01am")).to eq Time.new(2014, 11, 14, 8, 1, 0, 0) }
        specify { expect(time("8:01pm")).to eq Time.new(2014, 11, 14, 20, 1, 0, 0) }
        specify { expect(time("9:01")).to eq Time.new(2014, 11, 14, 9, 1, 0, 0) }
        specify { expect(time("9:01am")).to eq Time.new(2014, 11, 14, 9, 1, 0, 0) }
        specify { expect(time("9:01pm")).to eq Time.new(2014, 11, 14, 21, 1, 0, 0) }
        specify { expect(time("22:01")).to eq Time.new(2014, 11, 14, 22, 1, 0, 0) }
        specify { expect(time("22:01am")).to eq Time.new(2014, 11, 14, 22, 1, 0, 0) }
        specify { expect(time("22:01pm")).to eq Time.new(2014, 11, 14, 22, 1, 0, 0) }
        specify { expect(time("12:01")).to eq Time.new(2014, 11, 14, 12, 1, 0, 0) }
        specify { expect(time("12:01am")).to eq Time.new(2014, 11, 15, 0, 1, 0, 0) }
        specify { expect(time("12:01pm")).to eq Time.new(2014, 11, 14, 12, 1, 0, 0) }
        specify { expect(time("00:00")).to eq Time.new(2014, 11, 15, 0, 0, 0, 0) }
        specify { expect(time("04:01pm")).to eq Time.new(2014, 11, 14, 16, 1, 0, 0) }
        specify { expect(time("15.32pm")).to eq Time.new(2014, 11, 14, 15, 32, 0, 0) }
        specify { expect(time("4.01")).to eq Time.new(2014, 11, 14, 16, 1, 0, 0) }
        specify { expect(time("05.59")).to eq Time.new(2014, 11, 14, 17, 59, 0, 0) }
        specify { expect(time("323")).to eq Time.new(2014, 11, 14, 15, 23, 0, 0) }
        specify { expect(time("2312")).to eq Time.new(2014, 11, 14, 23, 12, 0, 0) }
        specify { expect(time("0902")).to eq Time.new(2014, 11, 14, 9, 2, 0, 0) }
        specify { expect(time("1123am")).to eq Time.new(2014, 11, 14, 11, 23, 0, 0) }
        specify { expect(time("0902")).to eq Time.new(2014, 11, 14, 9, 2, 0, 0) }
        specify { expect(time("2.06")).to eq Time.new(2014, 11, 14, 14, 6, 0, 0) }
      end

      describe "month and day" do
        specify { expect(time("11/15")).to eq Time.new(2014, 11, 15, 12, 0, 0, 0) }
        specify { expect(time("15/11")).to eq Time.new(2014, 11, 15, 12, 0, 0, 0) }
        specify { expect(time("1/3")).to eq Time.new(2015, 1, 3, 12, 0, 0, 0) }
        specify { expect(time("7/8")).to eq Time.new(2015, 7, 8, 12, 0, 0, 0) }
        specify { expect(time("01/05")).to eq Time.new(2015, 1, 5, 12, 0, 0, 0) }
        specify { expect(time("on 11/15")).to eq Time.new(2014, 11, 15, 12, 0, 0, 0) }
        specify { expect(time("Nov 15")).to eq Time.new(2014, 11, 15, 12, 0, 0, 0) }
        specify { expect(time("December 3")).to eq Time.new(2014, 12, 3, 12, 0, 0, 0) }
        specify { expect(time("oct 30")).to eq Time.new(2015, 10, 30, 12, 0, 0, 0) }
        specify { expect(time("july 02")).to eq Time.new(2015, 7, 2, 12, 0, 0, 0) }
        specify { expect(time("3 Jun")).to eq Time.new(2015, 6, 3, 12, 0, 0, 0) }
        specify { expect(time("12 January")).to eq Time.new(2015, 1, 12, 12, 0, 0, 0) }
        specify { expect(time("28 feb")).to eq Time.new(2015, 2, 28, 12, 0, 0, 0) }
        specify { expect(time("04 september")).to eq Time.new(2015, 9, 4, 12, 0, 0, 0) }
        specify { expect(time("2june")).to eq Time.new(2015, 6, 2, 12, 0, 0, 0) }
        specify { expect(time("feb09")).to eq Time.new(2015, 2, 9, 12, 0, 0, 0) }
        specify { expect(time("tomorrow")).to eq Time.new(2014, 11, 15, 12, 0, 0, 0) }
      end

      describe "year, month and day" do
        specify { expect(time("11/15/2016")).to eq Time.new(2016, 11, 15, 12, 0, 0, 0) }
        specify { expect(time("2/5/1900")).to eq Time.new(1900, 2, 5, 12, 0, 0, 0) }
        specify { expect(time("31/7/1900")).to eq Time.new(1900, 7, 31, 12, 0, 0, 0) }
        specify { expect(time("2015/05/30")).to eq Time.new(2015, 5, 30, 12, 0, 0, 0) }
        specify { expect(time("2015/12/05")).to eq Time.new(2015, 12, 5, 12, 0, 0, 0) }
        specify { expect(time("2015/31/05")).to eq Time.new(2015, 5, 31, 12, 0, 0, 0) }
        specify { expect(time("1723-04-07")).to eq Time.new(1723, 4, 7, 12, 0, 0, 0) }
        specify { expect(time("2014-30-09")).to eq Time.new(2014, 9, 30, 12, 0, 0, 0) }
        specify { expect(time("22-08-2013")).to eq Time.new(2013, 8, 22, 12, 0, 0, 0) }
        specify { expect(time("07-08-2013")).to eq Time.new(2013, 7, 8, 12, 0, 0, 0) }
        specify { expect(time("Nov 15 1923")).to eq Time.new(1923, 11, 15, 12, 0, 0, 0) }
        specify { expect(time("December 3 2013")).to eq Time.new(2013, 12, 3, 12, 0, 0, 0) }
        specify { expect(time("oct 30 1999")).to eq Time.new(1999, 10, 30, 12, 0, 0, 0) }
        specify { expect(time("july 02 2020")).to eq Time.new(2020, 7, 2, 12, 0, 0, 0) }
        specify { expect(time("3 Jun 2004")).to eq Time.new(2004, 6, 3, 12, 0, 0, 0) }
        specify { expect(time("12 January 1787")).to eq Time.new(1787, 1, 12, 12, 0, 0, 0) }
        specify { expect(time("28 feb 1245")).to eq Time.new(1245, 2, 28, 12, 0, 0, 0) }
        specify { expect(time("04 september 1955")).to eq Time.new(1955, 9, 4, 12, 0, 0, 0) }
        specify { expect(time("2009 Mar 3")).to eq Time.new(2009, 3, 3, 12, 0, 0, 0) }
        specify { expect(time("1991 June 30")).to eq Time.new(1991, 6, 30, 12, 0, 0, 0) }
        specify { expect(time("1756 apr 23")).to eq Time.new(1756, 4, 23, 12, 0, 0, 0) }
        specify { expect(time("1976 august 13")).to eq Time.new(1976, 8, 13, 12, 0, 0, 0) }
        specify { expect(time("1955 18 Sep")).to eq Time.new(1955, 9, 18, 12, 0, 0, 0) }
        specify { expect(time("1233 12 March")).to eq Time.new(1233, 3, 12, 12, 0, 0, 0) }
        specify { expect(time("1959 21 nov")).to eq Time.new(1959, 11, 21, 12, 0, 0, 0) }
        specify { expect(time("1877 08 october")).to eq Time.new(1877, 10, 8, 12, 0, 0, 0) }
        specify { expect(time("on 1923 23july")).to eq Time.new(1923, 7, 23, 12, 0, 0, 0) }
        specify { expect(time("on 2134 mar14")).to eq Time.new(2134, 3, 14, 12, 0, 0, 0) }
      end

      describe "month, day and hours" do
        specify { expect(time("7/8 9pm")).to eq Time.new(2015, 7, 8, 21, 0, 0, 0) }
        specify { expect(time("10/8 1")).to eq Time.new(2015, 10, 8, 1, 0, 0, 0) }
        specify { expect(time("10/5 @ 3pm")).to eq Time.new(2015, 10, 5, 15, 0, 0, 0) }
        specify { expect(time("on 11/15 at 3")).to eq Time.new(2014, 11, 15, 3, 0, 0, 0) }
        specify { expect(time("@ 3pm 10/5")).to eq Time.new(2015, 10, 5, 15, 0, 0, 0) }
        specify { expect(time("Jul 03 3")).to eq Time.new(2015, 7, 3, 3, 0, 0, 0) }
        specify { expect(time("February 14 4pm")).to eq Time.new(2015, 2, 14, 16, 0, 0, 0) }
        specify { expect(time("dec 23 @ 22")).to eq Time.new(2014, 12, 23, 22, 0, 0, 0) }
        specify { expect(time("august 02 at 1")).to eq Time.new(2015, 8, 2, 1, 0, 0, 0) }
        specify { expect(time("on 16 Mar 3")).to eq Time.new(2015, 3, 16, 3, 0, 0, 0) }
        specify { expect(time("5 March @ 1am")).to eq Time.new(2015, 3, 5, 1, 0, 0, 0) }
        specify { expect(time("28 dec 14")).to eq Time.new(2014, 12, 28, 14, 0, 0, 0) }
        specify { expect(time("04 july at 5am")).to eq Time.new(2015, 7, 4, 5, 0, 0, 0) }
        specify { expect(time("12pm Dec 04")).to eq Time.new(2014, 12, 4, 12, 0, 0, 0) }
        specify { expect(time("1am August 12")).to eq Time.new(2015, 8, 12, 1, 0, 0, 0) }
        specify { expect(time("03 on apr 19")).to eq Time.new(2015, 4, 19, 3, 0, 0, 0) }
        specify { expect(time("@ 20 january 22")).to eq Time.new(2015, 1, 22, 20, 0, 0, 0) }
        specify { expect(time("3 12 Feb")).to eq Time.new(2015, 2, 12, 3, 0, 0, 0) }
        specify { expect(time("8pm on 16 October")).to eq Time.new(2015, 10, 16, 20, 0, 0, 0) }
        specify { expect(time("13 02 mar")).to eq Time.new(2015, 3, 2, 13, 0, 0, 0) }
        specify { expect(time("@ 11 on 04 november")).to eq Time.new(2015, 11, 4, 11, 0, 0, 0) }
        specify { expect(time("tomorrow @ 1pm")).to eq Time.new(2014, 11, 15, 13, 0, 0, 0) }
        specify { expect(time("tomorrow 20")).to eq Time.new(2014, 11, 15, 20, 0, 0, 0) }
        specify { expect(time("tomorrow at 01")).to eq Time.new(2014, 11, 15, 1, 0, 0, 0) }
        specify { expect(time("4am tomorrow")).to eq Time.new(2014, 11, 15, 4, 0, 0, 0) }
        specify { expect(time("17 tomorrow")).to eq Time.new(2014, 11, 15, 17, 0, 0, 0) }
        specify { expect(time("@ 3 tomorrow")).to eq Time.new(2014, 11, 15, 3, 0, 0, 0) }
      end

      describe "month, day, hours and minutes" do
        specify { expect(time("11/14 04:23")).to eq Time.new(2015, 11, 14, 4, 23, 0, 0) }
        specify { expect(time("11/15 05:44")).to eq Time.new(2014, 11, 15, 5, 44, 0, 0) }
        specify { expect(time("15/11 1533")).to eq Time.new(2014, 11, 15, 15, 33, 0, 0) }
        specify { expect(time("1/3 13.00")).to eq Time.new(2015, 1, 3, 13, 0, 0, 0) }
        specify { expect(time("01/05 0213")).to eq Time.new(2015, 1, 5, 2, 13, 0, 0) }
        specify { expect(time("Jul 03 3")).to eq Time.new(2015, 7, 3, 3, 0, 0, 0) }
        specify { expect(time("February 14 423pm")).to eq Time.new(2015, 2, 14, 16, 23, 0, 0) }
        specify { expect(time("dec 23 @ 22:11")).to eq Time.new(2014, 12, 23, 22, 11, 0, 0) }
        specify { expect(time("august 02 at 112")).to eq Time.new(2015, 8, 2, 11, 2, 0, 0) }
        specify { expect(time("on 16 Mar 303")).to eq Time.new(2015, 3, 16, 3, 3, 0, 0) }
        specify { expect(time("5 March @ 1.42")).to eq Time.new(2015, 3, 5, 1, 42, 0, 0) }
        specify { expect(time("28 dec 14:59")).to eq Time.new(2014, 12, 28, 14, 59, 0, 0) }
        specify { expect(time("04 july at 5:10am")).to eq Time.new(2015, 7, 4, 5, 10, 0, 0) }
        specify { expect(time("1238pm Dec 04")).to eq Time.new(2014, 12, 4, 12, 38, 0, 0) }
        specify { expect(time("1:54am August 12")).to eq Time.new(2015, 8, 12, 1, 54, 0, 0) }
        specify { expect(time("0300 on apr 19")).to eq Time.new(2015, 4, 19, 3, 0, 0, 0) }
        specify { expect(time("@ 20.10 january 22")).to eq Time.new(2015, 1, 22, 20, 10, 0, 0) }
        specify { expect(time("3.56 12 Feb")).to eq Time.new(2015, 2, 12, 3, 56, 0, 0) }
        specify { expect(time("841pm on 16 October")).to eq Time.new(2015, 10, 16, 20, 41, 0, 0) }
        specify { expect(time("13.11 02 mar")).to eq Time.new(2015, 3, 2, 13, 11, 0, 0) }
        specify { expect(time("@ 1101 on 04 november")).to eq Time.new(2015, 11, 4, 11, 1, 0, 0) }
        specify { expect(time("tomorrow 14:23")).to eq Time.new(2014, 11, 15, 14, 23, 0, 0) }
        specify { expect(time("tomorrow at 0300")).to eq Time.new(2014, 11, 15, 3, 0, 0, 0) }
        specify { expect(time("tomorrow 345pm")).to eq Time.new(2014, 11, 15, 15, 45, 0, 0) }
        specify { expect(time("@ 0353 tomorrow")).to eq Time.new(2014, 11, 15, 3, 53, 0, 0) }
        specify { expect(time("at19.33 tomorrow")).to eq Time.new(2014, 11, 15, 19, 33, 0, 0) }
        specify { expect(time("1130 tomorrow")).to eq Time.new(2014, 11, 15, 11, 30, 0, 0) }
      end

      describe "year, month, day and hours" do
        specify { expect(time("22-08-2013 11")).to eq Time.new(2013, 8, 22, 11, 0, 0, 0) }
        specify { expect(time("07-08-2013 12")).to eq Time.new(2013, 7, 8, 12, 0, 0, 0) }
        specify { expect(time("2/5/1900 2am")).to eq Time.new(1900, 2, 5, 2, 0, 0, 0) }
        specify { expect(time("31/7/1900 12am")).to eq Time.new(1900, 7, 31, 0, 0, 0, 0) }
        specify { expect(time("2015-12-22 at 10")).to eq Time.new(2015, 12, 22, 10, 0, 0, 0) }
        specify { expect(time("at 10 2015-12-22")).to eq Time.new(2015, 12, 22, 10, 0, 0, 0) }
        specify { expect(time("Nov 15 1923 13")).to eq Time.new(1923, 11, 15, 13, 0, 0, 0) }
        specify { expect(time("5pm December 3 2013")).to eq Time.new(2013, 12, 3, 17, 0, 0, 0) }
        specify { expect(time("oct 30 1999 @ 1")).to eq Time.new(1999, 10, 30, 1, 0, 0, 0) }
        specify { expect(time("20 on july 02 2020")).to eq Time.new(2020, 7, 2, 20, 0, 0, 0) }
        specify { expect(time("3 Jun 2004 8am")).to eq Time.new(2004, 6, 3, 8, 0, 0, 0) }
        specify { expect(time("23pm 12 January 1787")).to eq Time.new(1787, 1, 12, 23, 0, 0, 0) }
        specify { expect(time("28 feb 1245 at 11")).to eq Time.new(1245, 2, 28, 11, 0, 0, 0) }
        specify { expect(time("@ 7am 04 september 1955")).to eq Time.new(1955, 9, 4, 7, 0, 0, 0) }
        specify { expect(time("on 2009 Mar 3 @ 4")).to eq Time.new(2009, 3, 3, 4, 0, 0, 0) }
        specify { expect(time("1991 June 30 at 7")).to eq Time.new(1991, 6, 30, 7, 0, 0, 0) }
        specify { expect(time("10 on 1756 apr 23")).to eq Time.new(1756, 4, 23, 10, 0, 0, 0) }
        specify { expect(time("1976 august 13 at 6pm")).to eq Time.new(1976, 8, 13, 18, 0, 0, 0) }
        specify { expect(time("2am 1955 18 Sep")).to eq Time.new(1955, 9, 18, 2, 0, 0, 0) }
        specify { expect(time("1233 12 March 4")).to eq Time.new(1233, 3, 12, 4, 0, 0, 0) }
        specify { expect(time("@ 04 1959 21 nov")).to eq Time.new(1959, 11, 21, 4, 0, 0, 0) }
        specify { expect(time("1877 08 october 03pm")).to eq Time.new(1877, 10, 8, 15, 0, 0, 0) }
      end

      describe "year, month, day, hour and minutes" do
        specify { expect(time("11/15/2016 333pm")).to eq Time.new(2016, 11, 15, 15, 33, 0, 0) }
        specify { expect(time("2015/05/30 1300")).to eq Time.new(2015, 5, 30, 13, 0, 0, 0) }
        specify { expect(time("2015/12/05 730")).to eq Time.new(2015, 12, 5, 7, 30, 0, 0) }
        specify { expect(time("2015/31/05 0000")).to eq Time.new(2015, 5, 31, 0, 0, 0, 0) }
        specify { expect(time("1723-04-07 22:59")).to eq Time.new(1723, 4, 7, 22, 59, 0, 0) }
        specify { expect(time("2014-30-09 11.2")).to eq Time.new(2014, 9, 30, 11, 2, 0, 0) }
        specify { expect(time("Nov 15 1923 13:10")).to eq Time.new(1923, 11, 15, 13, 10, 0, 0) }
        specify { expect(time("523pm December 3 2013")).to eq Time.new(2013, 12, 3, 17, 23, 0, 0) }
        specify { expect(time("oct 30 1999 @ 0100")).to eq Time.new(1999, 10, 30, 1, 0, 0, 0) }
        specify { expect(time("20:54 on july 02 2020")).to eq Time.new(2020, 7, 2, 20, 54, 0, 0) }
        specify { expect(time("3 Jun 2004 8.15am")).to eq Time.new(2004, 6, 3, 8, 15, 0, 0) }
        specify { expect(time("23.1pm 12 January 1787")).to eq Time.new(1787, 1, 12, 23, 1, 0, 0) }
        specify { expect(time("28 feb 1245 at 1112")).to eq Time.new(1245, 2, 28, 11, 12, 0, 0) }
        specify { expect(time("@ 7.45am 04 september 1955")).to eq Time.new(1955, 9, 4, 7, 45, 0, 0) }
        specify { expect(time("on 2009 Mar 3 @ 4:59")).to eq Time.new(2009, 3, 3, 4, 59, 0, 0) }
        specify { expect(time("1991 June 30 at 7.3")).to eq Time.new(1991, 6, 30, 7, 3, 0, 0) }
        specify { expect(time("10:34 on 1756 apr 23")).to eq Time.new(1756, 4, 23, 10, 34, 0, 0) }
        specify { expect(time("1976 august 13 at 620pm")).to eq Time.new(1976, 8, 13, 18, 20, 0, 0) }
        specify { expect(time("0203am 1955 18 Sep")).to eq Time.new(1955, 9, 18, 2, 3, 0, 0) }
        specify { expect(time("1233 12 March 444")).to eq Time.new(1233, 3, 12, 4, 44, 0, 0) }
        specify { expect(time("@ 04.37 1959 21 nov")).to eq Time.new(1959, 11, 21, 4, 37, 0, 0) }
        specify { expect(time("1877 08 october 03:18pm")).to eq Time.new(1877, 10, 8, 15, 18, 0, 0) }
        specify { expect(time("2014-11-20T18:46:41Z")).to eq Time.new(2014, 11, 20, 18, 46, 41, 0) }
        specify { expect(time("2014-11-14T07:00:00Z")).to eq Time.new(2014, 11, 14, 7, 0, 0, 0) }
      end
    end

    context "at 2014-12-31 13:00:00" do
      def now
        Time.new(2014, 12, 31, 13, 0, 0, 0)
      end

      describe "month and day" do
        specify { expect(time("tomorrow")).to eq Time.new(2015, 1, 1, 12, 0, 0, 0) }
      end
    end

    def time(string)
      described_class.new(string, now: now).time
    end
  end
end
