module Nar
  class Am
    def to_twentyfour(hour)
      if hour == 12
        0
      else
        hour
      end
    end

    def unspecified?
      false
    end
  end
end
