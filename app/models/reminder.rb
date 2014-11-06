class Reminder < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true
  validates :due_at, presence: true

  delegate :email, to: :user

  def self.due
    where("due_at < ? AND sent_at IS NULL", Time.current)
  end

  def mark_as_sent!
    update!(sent_at: Time.current)
  end
end
