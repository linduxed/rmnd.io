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
  end

  describe "self.due" do
    it "returns due reminders" do
      travel_to Time.current do
        create(described_class, due_at: 2.minutes.ago, sent_at: 1.minute.ago)
        due = [
          create(described_class, due_at: 1.minute.ago, sent_at: nil),
          create(described_class, due_at: 1.minute.ago, sent_at: 2.minutes.ago),
        ]

        expect(described_class.due).to match_array due
      end
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
end
