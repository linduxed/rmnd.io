module Nar
  class Pm
    def to_twentyfour(hour)
      if hour < 12
        hour + 12
      else
        hour
      end
    end

    def unspecified?
      false
    end
  end
end
