require "spec_helper"
require "nar/date_guess"

describe Nar::DateGuess do
  describe "#ambiguous?" do
    context "when everything is ambiguous" do
      it "returns true" do
        guess = described_class.new

        expect(guess).to be_ambiguous
      end
    end

    context "when month and day are ambiguous" do
      it "returns true" do
        guess = described_class.new(year: 2014)

        expect(guess).to be_ambiguous
      end
    end

    context "when year and day are ambiguous" do
      it "returns true" do
        guess = described_class.new(month: 5)

        expect(guess).to be_ambiguous
      end
    end

    context "when year and month are ambiguous" do
      it "returns true" do
        guess = described_class.new(day: 5)

        expect(guess).to be_ambiguous
      end
    end

    context "when day is ambiguous" do
      it "returns true" do
        guess = described_class.new(year: 2014, month: 5)

        expect(guess).to be_ambiguous
      end
    end

    context "when month is ambiguous" do
      it "returns true" do
        guess = described_class.new(year: 2014, day: 5)

        expect(guess).to be_ambiguous
      end
    end

    context "when year is ambiguous" do
      it "returns true" do
        guess = described_class.new(month: 5, day: 5)

        expect(guess).to be_ambiguous
      end
    end

    context "when nothing is ambiguous" do
      it "returns false" do
        guess = described_class.new(year: 2014, month: 5, day: 5)

        expect(guess).not_to be_ambiguous
      end
    end
  end

  describe "#date" do
    context "when everything is ambiguous" do
      it "returns the current date" do
        guess = described_class.new

        expect(guess.date(Date.new(2014, 11, 15))).to eq Date.new(2014, 11, 15)
      end
    end

    context "when month and day are ambiguous" do
      it "returns the first of January that year" do
        guess = described_class.new(year: 2015)

        expect(guess.date(Date.new(2014, 11, 15))).to eq Date.new(2015, 1, 1)
      end
    end

    context "when year and day are ambiguous" do
      context "when the month is in the future" do
        it "returns the first of that month the current year" do
          guess = described_class.new(month: 12)

          expect(guess.date(Date.new(2014, 11, 15))).to eq Date.new(2014, 12, 1)
        end
      end

      context "when the month is the current" do
        it "returns the first of that month next year" do
          guess = described_class.new(month: 11)

          expect(guess.date(Date.new(2014, 11, 15))).to eq Date.new(2015, 11, 1)
          expect(guess.date(Date.new(2014, 11, 1))).to eq Date.new(2015, 11, 1)
        end
      end

      context "when the month is in the past" do
        it "returns the first of that month next year" do
          guess = described_class.new(month: 10)

          expect(guess.date(Date.new(2014, 11, 15))).to eq Date.new(2015, 10, 1)
        end
      end
    end

    context "when year and month are ambiguous" do
      context "when the day is in the future" do
        it "returns that day of the current month the current year" do
          guess = described_class.new(day: 16)

          expect(guess.date(Date.new(2014, 11, 15))).to eq Date.new(2014, 11, 16)
        end
      end

      context "when the day is the current" do
        it "returns that day of the next month" do
          guess = described_class.new(day: 15)

          expect(guess.date(Date.new(2014, 11, 15))).to eq Date.new(2014, 12, 15)

          guess = described_class.new(day: 15)

          expect(guess.date(Date.new(2014, 12, 15))).to eq Date.new(2015, 1, 15)
        end
      end

      context "when the day is in the past" do
        it "returns that day of the next month" do
          guess = described_class.new(day: 14)

          expect(guess.date(Date.new(2014, 11, 15))).to eq Date.new(2014, 12, 14)

          guess = described_class.new(day: 14)

          expect(guess.date(Date.new(2014, 12, 15))).to eq Date.new(2015, 1, 14)
        end
      end
    end

    context "when day is ambiguous" do
      it "returns the first of the that month that year" do
        guess = described_class.new(year: 2015, month: 3)

        expect(guess.date(Date.new(2014, 11, 15))).to eq Date.new(2015, 3, 1)
      end
    end

    context "when month is ambiguous" do
      it "returns the day of January that year" do
        guess = described_class.new(year: 2015, day: 3)

        expect(guess.date(Date.new(2014, 11, 15))).to eq Date.new(2015, 1, 3)
      end
    end

    context "when year is ambiguous" do
      context "when day and month are in the future" do
        it "returns that day of that month the current year" do
          guess = described_class.new(month: 12, day: 3)

          expect(guess.date(Date.new(2014, 11, 15))).to eq Date.new(2014, 12, 3)
        end
      end

      context "when day and month are the current" do
        it "returns that day of that month the next year" do
          guess = described_class.new(month: 11, day: 15)

          expect(guess.date(Date.new(2014, 11, 15))).to eq Date.new(2015, 11, 15)
        end
      end

      context "when day and month are in the past" do
        it "returns that day of that month the next year" do
          guess = described_class.new(month: 11, day: 14)

          expect(guess.date(Date.new(2014, 11, 15))).to eq Date.new(2015, 11, 14)
        end
      end
    end

    context "when nothing is ambiguous" do
      it "returns the date" do
        guess = described_class.new(year: 2015, month: 3, day: 21)

        expect(guess.date(Date.new(2014, 11, 15))).to eq Date.new(2015, 3, 21)
      end
    end
  end
end
