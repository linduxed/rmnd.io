Clearance.configure do |config|
  config.mailer_sender = ENV.fetch("MAILER_SENDER")
  config.routes = false
end
