module Features
  def field(name)
    t(name, scope: "simple_form.labels")
  end

  def button(name)
    t(name, scope: "helpers.submit")
  end

  def repeat_frequency(name)
    t(name, scope: "reminders.repeat_frequencies")
  end
end
