RSpec.configure do |config|
  config.around :each do |example|
    cached_backend = Analytics.backend
    example.run
    Analytics.backend = cached_backend
  end
end

module Features
  def analytics
    Analytics.backend
  end
end
