require "rake"

module Features
  def run_rake_task(task)
    Rake::Task.clear
    Rmnd::Application.load_tasks
    Rake::Task[task].invoke
  end
end
