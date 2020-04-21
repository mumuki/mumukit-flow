require "bundler/setup"
require "mumukit/flow"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def build_guide_with(exercises)
  DemoGuide.new(exercises)
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

  attr_accessor :structural_parent

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
  end

  def assignment_for(_submitter=nil)
    @assignment ||= DemoAssignment.new self
  end

  def accept_submission_status!(status)
    assignment_for.accept_submission_status! status
  end
end

class DemoGuide < DemoBaseContent
  attr_accessor :structural_children

  def initialize(exercises)
    @structural_children = exercises
    exercises.merge_numbers!
    exercises.each { |it| it.structural_parent = self }
  end

  def exercise_assignments_for(_submitter)
    structural_children.map(&:assignment).compact
  end
end
