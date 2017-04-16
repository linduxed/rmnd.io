require "rails_helper"

describe ReminderForm do
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:due_date) }
    it {
      is_expected.to validate_inclusion_of(:repeat_frequency).
        in_array(Reminder.repeat_frequencies.keys).
        allow_blank(true)
    }
    it { is_expected.to allow_value(1.second.from_now.iso8601).for(:due_date) }
    it { is_expected.to_not allow_value("unparseable").for(:due_date) }
    it { is_expected.to_not allow_value(1.second.ago.iso8601).for(:due_date) }
  end

  describe ".find" do
    context "when a reminder with the passed id exsits" do
      it "returns a reminder form with the reminder and attributes" do
        reminder_factory = double(:reminder_factory)
        reminder = double(:reminder)
        allow(reminder).to receive(:attributes).and_return(
          "title" => "Do this",
          "due_date" => "2014-11-23T14:29:00Z",
          "repeat_frequency" => "daily",
          "unrelated" => "skip this",
        )
        allow(reminder_factory).to receive(:find).and_return(reminder)
        form = ReminderForm.find("1", reminder_factory: reminder_factory)

        expect(reminder_factory).to have_received(:find).with("1")
        expect(form.reminder).to eq reminder
        expect(form.title).to eq "Do this"
        expect(form.due_date).to eq "2014-11-23T14:29:00Z"
        expect(form.repeat_frequency).to eq "daily"
      end
    end

    context "when a reminder with the passed id doesn't exsit" do
      it "raises an error" do
        reminder_factory = double(:reminder_factory)
        allow(reminder_factory).to receive(:find).
          and_raise(ActiveRecord::RecordNotFound)

        expect {
          ReminderForm.find("1", reminder_factory: reminder_factory)
        }.to raise_error(ActiveRecord::RecordNotFound)

        expect(reminder_factory).to have_received(:find).with("1")
      end
    end
  end

  describe "#save" do
    context "when valid" do
      it "creates a reminder and returns true" do
        travel_to Time.new(2014, 11, 23, 14, 0, 0, 0) do
          reminder_factory = double(:reminder_factory)
          reminder = double(:reminder)
          allow(reminder_factory).to receive(:new).and_return(reminder)
          allow(reminder).to receive(:save!)
          form = ReminderForm.new(
            title: "Do this",
            due_date: "2014-11-23T14:29:00Z",
            repeat_frequency: "daily",
          )

          expect(form.save(reminder_factory: reminder_factory)).to eq true
          expect(reminder_factory).to have_received(:new).with(
            title: "Do this",
            due_date: "2014-11-23T14:29:00Z",
            due_at: Time.new(2014, 11, 23, 14, 29, 0, 0),
            repeat_frequency: "daily",
          )
          expect(reminder).to have_received(:save!)
          expect(form.reminder).to eq reminder
        end
      end
    end

    context "when invalid" do
      it "doesn't call save! on the reminder and returns false" do
        reminder_factory = double(:reminder_factory)
        reminder = double(:reminder)
        allow(reminder_factory).to receive(:new).and_return(reminder)
        allow(reminder).to receive(:save!)
        form = ReminderForm.new

        expect(form.save(reminder_factory: reminder_factory)).to eq false
        expect(reminder_factory).not_to have_received(:new)
        expect(reminder).not_to have_received(:save!)
      end
    end
  end

  describe "#update" do
    context "when valid" do
      it "updates the reminder and returns true" do
        travel_to Time.new(2014, 11, 23, 14, 0, 0, 0) do
          reminder = double(:reminder)
          allow(reminder).to receive(:update!)
          form = ReminderForm.new(reminder: reminder)

          return_value = form.update(
            title: "Do this",
            due_date: "2014-11-23T14:29:00Z",
            repeat_frequency: "daily",
          )

          expect(return_value).to eq true
          expect(reminder).to have_received(:update!).with(
            title: "Do this",
            due_date: "2014-11-23T14:29:00Z",
            due_at: Time.new(2014, 11, 23, 14, 29, 0, 0),
            repeat_frequency: "daily",
          )
        end
      end
    end

    context "when invalid" do
      it "doesn't update the reminder and returns false" do
        reminder = double(:reminder)
        allow(reminder).to receive(:update!)
        form = ReminderForm.new(reminder: reminder)

        expect(form.update).to eq false
        expect(reminder).not_to have_received(:update!)
      end
    end
  end

  describe "#repeat_frequencies" do
    it "returns Reminder.repeat_frequencies" do
      form = ReminderForm.new

      expect(form.repeat_frequencies).to eq Reminder.repeat_frequencies
    end
  end

  describe "#persisted?" do
    context "when reminder is set" do
      it "returns Reminder#persisted?" do
        persisted = double(:persisted)
        reminder = double(:reminder)
        allow(reminder).to receive(:persisted?).and_return(persisted)
        form = ReminderForm.new(reminder: reminder)

        expect(form.persisted?).to eq persisted
      end
    end

    context "when reminder unset" do
      it "returns false" do
        expect(ReminderForm.new).not_to be_persisted
      end
    end
  end
end
