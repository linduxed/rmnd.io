module Nar
  class UnspecifiedMeridiem
    def to_twentyfour(hour)
      hour
    end

    def unspecified?
      true
    end
  end
end
