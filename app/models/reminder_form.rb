require "nar/parser"

class ReminderForm
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Conversion

  attr_accessor :title, :due_date, :repeat_frequency
  attr_reader :reminder

  validates :title, presence: true
  validates :due_date, presence: true
  validates :repeat_frequency, inclusion: {
    in: Reminder.repeat_frequencies.keys,
    allow_blank: true
  }

  before_validation :parse_due_date

  def self.find(id, reminder_factory:)
    reminder = reminder_factory.find(id)
    attributes = reminder.
      attributes.
      slice("title", "due_date", "repeat_frequency").
      symbolize_keys.
      merge(reminder: reminder)
    new(attributes)
  end

  def initialize(attributes = {})
    self.attributes = attributes
  end

  def save(reminder_factory:)
    if valid?
      reminder_factory.new(reminder_attributes).save!
      true
    else
      false
    end
  end

  def update(attributes = {})
    self.attributes = attributes
    if valid?
      reminder.update!(reminder_attributes)
      true
    else
      false
    end
  end

  def repeat_frequencies
    Reminder.repeat_frequencies
  end

  def persisted?
    reminder.try(:persisted?)
  end

  private

  attr_accessor :due_at
  attr_reader :reminder_factory
  attr_writer :reminder

  def attributes=(attributes)
    attributes.each do |attribute, value|
      send("#{attribute}=", value)
    end
  end

  def reminder_attributes
    {
      title: title,
      due_date: due_date,
      due_at: due_at,
      repeat_frequency: repeat_frequency,
    }
  end

  def parse_due_date
    if due_date.present?
      now = Time.current
      self.due_at = Nar::Parser.new(due_date, now: now).time
      if due_at.blank?
        errors.add :due_date, :invalid
      elsif due_at < now
        errors.add :due_date, :past
      end
    end
  end
end
