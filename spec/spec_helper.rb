require "bundler/setup"
require "mumukit/flow"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

class DemoAssignment
  include Mumukit::Flow::AdaptiveAssignment

  attr_accessor :item, :status, :submissions_count, :submitter

  def initialize(item)
    @item = item
    @status = :pending
    @submissions_count = 0
  end

  def accept_submission_status!(status)
    @status = status
    @submissions_count += 1
  end

  def passed?
    @status == :passed
  end

  def skip_if_pending!
    if @status == :pending
      @status = :passed
    end
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

  delegate :accept_submission_status!, to: :assignment

  def initialize(type, tags=['A', 'B'])
    @type = type
    @tags = tags
    @assignment = DemoAssignment.new(self)
  end

  def assignment_for(_submitter)
    assignment
  end
end

class DemoGuide < DemoBaseContent
  attr_accessor :children

  def initialize(exercises)
    @children = exercises
    exercises.merge_numbers!
    exercises.each { |it| it.parent = self }
  end

  def exercise_assignments_for(_submitter)
    children.map(&:assignment)
  end
end
