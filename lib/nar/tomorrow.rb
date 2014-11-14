module Nar
  class Tomorrow
    def date(current)
      current.tomorrow
    end

    def ambiguous?
      false
    end
  end
end
