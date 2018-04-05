require "bundler/setup"
require "mumukit/flow"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end



class DemoBaseAssignment
  include Mumukit::Flow::Assignment::Helpers

  attr_reader :children, :submissions_count, :item, :parent

  def initialize(item, children)
    @item = item
    @children = children
    children.each { |it| it.instance_variable_set :@parent, self }
    @submissions_count = 0
  end

  def passed?
    @status == :passed
  end
end

class DemoExerciseAssignment < DemoBaseAssignment
  attr_reader :status

  def initialize(item)
    super(item, [])
  end

  def accept_submission_status!(status)
    @status = status
    @submissions_count += 1
  end

  def finished?
    passed?
  end
end

class DemoGuideAssignment < DemoBaseAssignment
  attr_accessor :closed

  def finished?
    closed || children.all?(&:finished?)
  end

  # Must be called when you know that the exercise has been finished
  def close!
    @closed = true
    @submissions_count = children.map { |it| it.submissions_count }.sum
    super
  end
end

class DemoBaseContent
  include Mumukit::Flow::Node

  attr_reader :parent

  def learning?
    @type == :learning
  end

  def practice?
    @type == :practice
  end
end

class DemoExercise < DemoBaseContent
  attr_accessor :number
  def initialize(type)
    @type = type
  end
end

class DemoGuide < DemoBaseContent
  def initialize(exercises)
    @exercises = exercises
    exercises.merge_numbers!
    exercises.each { |it| it.instance_variable_set :@parent, self }
  end

  def children
    @exercises
  end
end
