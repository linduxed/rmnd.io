require "decorator"

class FutureReminder < Decorator
  include ActiveModel::Validations

  validates :title, presence: true
  validates :due_at, presence: true
  validate :due_at_must_be_in_the_future

  def save
    if valid?
      save!
      true
    else
      false
    end
  end

  def update(attributes)
    self.attributes = attributes
    save
  end

  private

  def due_at_must_be_in_the_future
    if due_at.present? && due_at <= Time.current
      errors.add :due_at, :past
      self.due_at = nil
    end
  end
end
