RSpec::Matchers.define :deny_guest_access_to do
  match do
    send(http_method, action, @params)

    expect(response).to redirect_to(controller.sign_in_path)
  end

  def with_params(params)
    @params = params
    self
  end

  def description
    "deny guest access to #{http_method.upcase} #{action}"
  end

  def http_method
    expected.keys.first
  end

  def action
    expected.values.first
  end
end
