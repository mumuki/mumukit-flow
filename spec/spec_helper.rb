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
  assignments = exercises.map { |exercise| exercise.assignment= DemoAssignment.new }
  guide = DemoGuide.new(exercises)
  guide_assignment = DemoGuideAssignment.new(guide, assignments)

  guide_assignment.children
end

class DemoAssignment
  include Mumukit::Flow::AdaptiveAssignment
  include Mumukit::Flow::AdaptiveAssignment::Terminal

  attr_accessor :submissions_count
  attr_accessor :status

  def initialize
    @submissions_count = 0
  end

  def accept_submission_status!(status)
    @status = status
    @submissions_count += 1
  end

  def passed?
    @status == :passed
  end

end

class DemoBaseContent
  include Mumukit::Flow::AdaptiveItem

  attr_accessor :parent

  def learning?
    @type == :learning
  end

  def practice?
    @type == :practice
  end
end

class DemoExercise < DemoBaseContent
  attr_accessor :number, :tags, :assignment

  def initialize(type, tags=['A', 'B'])
    @type = type
    @tags = tags
    @assignment = DemoAssignment.new
  end
end

class DemoGuide < DemoBaseContent
  attr_accessor :children

  def initialize(exercises)
    @children = exercises
    exercises.merge_numbers!
    exercises.each { |it| it.parent = self }
  end
end
