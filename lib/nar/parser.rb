require "parslet"
require "nar/internal_parser"
require "nar/transform"

module Nar
  class Parser
    def initialize(string, now:)
      @string = string
      @now = now
      @parser = InternalParser.new
      @transform = Transform.new
    end

    def time
      t = parser.parse(string)
      transform.apply(t).time(now)
    rescue Parslet::ParseFailed
      nil
    end

    private

    attr_reader :string, :now, :parser, :transform
  end
end
