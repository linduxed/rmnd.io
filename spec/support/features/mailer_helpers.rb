module Features
  def emails
    ActionMailer::Base.deliveries
  end
end
