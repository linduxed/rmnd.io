class User < ActiveRecord::Base
  include Clearance::User

  has_many :reminders, dependent: :destroy

  validates :time_zone, presence: true,
    inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }

  def unsent_reminders
    reminders.unsent
  end

  def require_email_confirmation!
    update!(
      email_confirmed_at: nil,
      email_confirmation_token: SecureRandom.hex(20).encode('UTF-8'),
    )
  end

  def confirm_email!
    update!(email_confirmed_at: Time.current)
  end

  def email_confirmed?
    email_confirmed_at.present?
  end
end
