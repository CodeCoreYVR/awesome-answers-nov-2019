class HelloWorldJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    puts "-------------------------"
    puts "Running a job .. 🏃🏻‍♂️🏃🏻‍♀️"
    puts "-------------------------"
  end
end
