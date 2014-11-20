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
      time_factory.time(now)
    rescue Parslet::ParseFailed
      nil
    end

    private

    def time_factory
      transform.apply(tree)
    end

    def tree
      parser.parse(string)
    end

    attr_reader :string, :now, :parser, :transform
  end
end
