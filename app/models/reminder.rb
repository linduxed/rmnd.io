class Reminder < ActiveRecord::Base
  enum repeat_frequency: {
    daily: 0,
    weekly: 1,
    monthly: 2,
    yearly: 3,
  }

  belongs_to :user

  validates :title, presence: true
  validates :due_at, presence: true

  delegate :email, :email_confirmed?, to: :user
  delegate :repeat_frequencies, to: :class

  def self.due
    where("due_at < ? AND (sent_at IS NULL OR sent_at < due_at)", Time.current).
      uncancelled
  end

  def self.uncancelled
    where("cancelled_at IS NULL")
  end

  def self.ordered
    order("sent_at IS NOT NULL AND repeat_frequency IS NULL, due_at ASC")
  end

  def self.unsent
    where("sent_at IS NULL OR repeat_frequency IS NOT NULL")
  end

  def mark_as_sent!
    if repeating?
      update!(sent_at: Time.current, due_at: due_at + distance_to_next_due_date)
    else
      update!(sent_at: Time.current)
    end
  end

  def repeating?
    repeat_frequency.present?
  end

  def due_at=(due_at)
    if due_at.is_a? String
      super parsed_time(due_at)
    else
      super
    end
  end

  def cancel!
    update!(cancelled_at: Time.current)
  end

  def sent?
    sent_at.present? && !repeating?
  end

  def unsent?
    !sent?
  end

  private

  def distance_to_next_due_date
    case repeat_frequency
    when "daily" then 1.day
    when "weekly" then 1.week
    when "monthly" then 1.month
    when "yearly" then 1.year
    end
  end

  def parsed_time(string)
    time = Chronic.parse(string)

    if time.present?
      time.localtime
    end
  end
end
