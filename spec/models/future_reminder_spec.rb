require "rails_helper"

describe FutureReminder do
  describe "validations" do
    subject { described_class.new(build_stubbed(:reminder)) }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:due_at) }
    it { should_not allow_value(1.second.ago).for(:due_at) }
    it { should allow_value(1.second.from_now).for(:due_at) }
  end

  describe "save" do
    context "when valid" do
      it "calls save! on the reminder and returns true" do
        reminder = build_stubbed(:reminder)
        allow(reminder).to receive(:save!)
        form = described_class.new(reminder)

        expect(form.save).to eq true
        expect(reminder).to have_received(:save!)
      end
    end

    context "when invalid" do
      it "doesn't call save! on the reminder and returns false" do
        reminder = build_stubbed(:reminder)
        allow(reminder).to receive(:save!)
        form = described_class.new(reminder)
        form.title = nil

        expect(form.save).to eq false
        expect(reminder).not_to have_received(:save!)
      end
    end
  end

  describe "update" do
    context "when valid" do
      it "calls save! on the reminder and returns true" do
        reminder = build_stubbed(:reminder)
        allow(reminder).to receive(:save!)
        form = described_class.new(reminder)

        expect(form.update(title: "Something")).to eq true
        expect(reminder).to have_received(:save!)
      end
    end

    context "when invalid" do
      it "doesn't call save! on the reminder and returns false" do
        reminder = build_stubbed(:reminder)
        allow(reminder).to receive(:save!)
        form = described_class.new(reminder)

        expect(form.update(title: nil)).to eq false
        expect(reminder).not_to have_received(:save!)
      end
    end
  end
end
