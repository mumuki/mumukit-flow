require "bundler/setup"
require "mumukit/flow"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def assignments_for(exercises)
  assignments = exercises.map { |exercise| DemoExerciseAssignment.new(exercise) }
  guide = DemoGuide.new(exercises)
  guide_assignment = DemoGuideAssignment.new(guide, assignments)

  guide_assignment.children
end

class DemoBaseAssignment
  include Mumukit::Flow::FlowableAssignment

  attr_accessor :submissions_count, :item, :parent

  def initialize(item, children)
    @item = item
    @children = children
    children.each { |it| it.parent = self }
    @submissions_count = 0
  end
end

class DemoExerciseAssignment < DemoBaseAssignment
  include Mumukit::Flow::FlowableAssignment::Terminal

  attr_accessor :status, :parent

  def initialize(item)
    super(item, [])
  end

  def accept_submission_status!(status)
    @status = status
    @submissions_count += 1
  end

  def passed?
    @status == :passed
  end

end

class DemoGuideAssignment < DemoBaseAssignment
  attr_accessor :closed, :children
  alias closed? closed
end

class DemoBaseContent
  include Mumukit::Flow::Node

  attr_accessor :parent

  def learning?
    @type == :learning
  end

  def practice?
    @type == :practice
  end
end

class DemoExercise < DemoBaseContent
  attr_accessor :number, :tags
  def initialize(type, tags=['A', 'B'])
    @type = type
    @tags = tags
  end
end

class DemoGuide < DemoBaseContent
  attr_accessor :exercises

  def initialize(exercises)
    @exercises = exercises
    exercises.merge_numbers!
    exercises.each { |it| it.parent = self }
  end

  def children
    @exercises
  end
end
