require "rails_helper"

describe Reminder do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:due_at) }
  end

  describe "delegations" do
    it { should delegate_method(:email).to(:user) }
    it { should delegate_method(:email_confirmed?).to(:user) }
    it { should delegate_method(:repeat_frequencies).to(:class) }
  end

  describe "self.due" do
    it "returns due reminders" do
      travel_to Time.current do
        create(described_class, due_at: 2.minutes.ago, sent_at: 1.minute.ago)
        create(described_class, :cancelled, due_at: 1.minute.ago, sent_at: nil)
        due = [
          create(described_class, due_at: 1.minute.ago, sent_at: nil),
          create(described_class, due_at: 1.minute.ago, sent_at: 2.minutes.ago),
        ]

        expect(described_class.due).to match_array due
      end
    end
  end

  describe "self.uncancelled" do
    it "returns reminders that are not cancelled" do
      create(described_class, :cancelled)
      uncancelled = [create(described_class, :uncancelled)]

      expect(described_class.uncancelled).to match_array uncancelled
    end
  end

  describe "self.ordered" do
    it "returns reminders ordered by due date with unsent before sent" do
      create(
        described_class,
        title: "Take out the dog",
        due_at: 5.hours.from_now,
        sent_at: 10.minutes.ago,
        repeat_frequency: :daily,
      )
      create(
        described_class,
        title: "Take out the trash",
        due_at: 1.day.from_now,
        sent_at: nil,
      )
      create(
        described_class,
        title: "Sign up for rmnd.io",
        due_at: 1.day.ago,
        sent_at: 1.day.ago,
        repeat_frequency: nil,
      )
      create(
        described_class,
        title: "Buy milk",
        due_at: 2.days.from_now,
        sent_at: nil,
      )

      expect(described_class.ordered.map(&:title)).to eq [
        "Take out the dog",
        "Take out the trash",
        "Buy milk",
        "Sign up for rmnd.io",
      ]
    end
  end

  describe "self.unsent" do
    it "returns unsent reminders" do
      create(:reminder, :sent)
      unsent = [
        create(:reminder, :unsent),
        create(:reminder, :sent, :repeating),
      ]

      expect(described_class.unsent).to eq unsent
    end
  end

  describe "mark_as_sent!" do
    context "when repeating daily" do
      it "sets sent at and updates due at" do
        travel_to Time.current do
          reminder = create(
            described_class,
            due_at: 1.minute.ago,
            sent_at: nil,
            repeat_frequency: :daily,
          )

          reminder.mark_as_sent!

          expect(reminder.sent_at).to eq(Time.current)
          expect(reminder.due_at).to eq(1.minute.ago + 1.day)
        end
      end
    end

    context "when repeating weekly" do
      it "sets sent at and updates due at" do
        travel_to Time.current do
          reminder = create(
            described_class,
            due_at: 1.minute.ago,
            sent_at: nil,
            repeat_frequency: :weekly,
          )

          reminder.mark_as_sent!

          expect(reminder.sent_at).to eq(Time.current)
          expect(reminder.due_at).to eq(1.minute.ago + 1.week)
        end
      end
    end

    context "when repeating monthly" do
      it "sets sent at and updates due at" do
        travel_to Time.current do
          reminder = create(
            described_class,
            due_at: 1.minute.ago,
            sent_at: nil,
            repeat_frequency: :monthly,
          )

          reminder.mark_as_sent!

          expect(reminder.sent_at).to eq(Time.current)
          expect(reminder.due_at).to eq(1.minute.ago + 1.month)
        end
      end
    end

    context "when repeating yearly" do
      it "sets sent at and updates due at" do
        travel_to Time.current do
          reminder = create(
            described_class,
            due_at: 1.minute.ago,
            sent_at: nil,
            repeat_frequency: :yearly,
          )

          reminder.mark_as_sent!

          expect(reminder.sent_at).to eq(Time.current)
          expect(reminder.due_at).to eq(1.minute.ago + 1.year)
        end
      end
    end

    context "when not repeating" do
      it "sets sent at" do
        travel_to Time.current do
          reminder = create(
            described_class,
            due_at: 1.minute.ago,
            sent_at: nil,
            repeat_frequency: nil,
          )

          reminder.mark_as_sent!

          expect(reminder.sent_at).to eq(Time.current)
          expect(reminder.due_at).to eq(1.minute.ago)
        end
      end
    end
  end

  describe "repeating?" do
    context "when repeat frequency is present" do
      it "returns true" do
        reminder = described_class.new(repeat_frequency: :daily)

        expect(reminder).to be_repeating
      end
    end

    context "when repeat frequency is nil" do
      it "returns false" do
        reminder = described_class.new(repeat_frequency: nil)

        expect(reminder).not_to be_repeating
      end
    end
  end

  describe "#due_at=" do
    it "accepts times" do
      time = Time.current
      reminder = described_class.new

      reminder.due_at = time

      expect(reminder.due_at).to eq(time)
    end

    it "accepts datetimes" do
      datetime = DateTime.current
      reminder = described_class.new

      reminder.due_at = datetime

      expect(reminder.due_at).to eq(datetime)
    end

    it "accepts strings" do
      reminder = described_class.new

      reminder.due_at = "2014-11-07 21:58"

      expect(reminder.due_at).to eq(Time.utc(2014, 11, 7, 21, 58))
    end

    it "accepts human readable strings" do
      reminder = described_class.new

      reminder.due_at = "tomorrow at 4"

      expect(reminder.due_at).to eq(1.day.from_now.change(hour: 16))
    end
  end

  describe "#cancel!" do
    it "cancels the reminder" do
      travel_to Time.current.beginning_of_minute do
        reminder = create(described_class, cancelled_at: nil)

        reminder.cancel!

        reminder.reload
        expect(reminder.cancelled_at).to eq(Time.current)
      end
    end
  end

  describe "#sent?" do
    context "when repeat frequency is nil" do
      context "when the reminder has been sent" do
        it "returns true" do
          reminder = described_class.new(sent_at: Time.current)

          expect(reminder).to be_sent
        end
      end

      context "when the reminder has not been sent" do
        it "returns false" do
          reminder = described_class.new(sent_at: nil)

          expect(reminder).not_to be_sent
        end
      end
    end

    context "when repeat frequency is not nil" do
      context "when the reminder has been sent" do
        it "returns false" do
          reminder = described_class.new(
            sent_at: Time.current,
            repeat_frequency: :daily,
          )

          expect(reminder).not_to be_sent
        end
      end

      context "when the reminder has not been sent" do
        it "returns false" do
          reminder = described_class.new(sent_at: nil, repeat_frequency: :daily)

          expect(reminder).not_to be_sent
        end
      end
    end
  end

  describe "#unsent?" do
    context "when repeat frequency is nil" do
      context "when the reminder has been sent" do
        it "returns false" do
          reminder = described_class.new(sent_at: Time.current)

          expect(reminder).not_to be_unsent
        end
      end

      context "when the reminder has not been sent" do
        it "returns true" do
          reminder = described_class.new(sent_at: nil)

          expect(reminder).to be_unsent
        end
      end
    end

    context "when repeat frequency is not nil" do
      context "when the reminder has been sent" do
        it "returns true" do
          reminder = described_class.new(
            sent_at: Time.current,
            repeat_frequency: :daily,
          )

          expect(reminder).to be_unsent
        end
      end

      context "when the reminder has not been sent" do
        it "returns true" do
          reminder = described_class.new(sent_at: nil, repeat_frequency: :daily)

          expect(reminder).to be_unsent
        end
      end
    end
  end
end
