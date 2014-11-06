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

  delegate :email, to: :user

  def self.due
    where("due_at < ? AND (sent_at IS NULL OR sent_at < due_at)", Time.current)
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

  private

  def distance_to_next_due_date
    case repeat_frequency
    when "daily" then 1.day
    when "weekly" then 1.week
    when "monthly" then 1.month
    when "yearly" then 1.year
    end
  end
end