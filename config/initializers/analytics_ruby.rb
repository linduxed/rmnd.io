require "segment/analytics"

AnalyticsRuby = Segment::Analytics.new({
    write_key: ENV.fetch("SEGMENT_IO_KEY"),
    on_error: Proc.new { |status, msg| print msg }
})
