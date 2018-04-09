def build_guide(*kinds)
  DemoGuide.new(kinds.map { |it| DemoExercise.new(it) })
end

def build_guide_flow(guide)
  GuideFlow.new(guide)
end

class GuideFlow
  def initialize(guide)
    @guide = guide
    @exercise_assignments = []
    @guide_assignment = DemoGuideAssignment.new(guide, @exercise_assignments)
    seek! 1
  end

  def submit!(status)
    @current.accept_submission_status! status
    if @current.passed?
      item = @current.next_suggested_item
      if item
        seek! item.number
      else
        @current = nil
      end
    end
  end

  def seek!(number)
    exercise = @guide.exercises[number - 1]

    @current = @guide_assignment.children.find { |it| it.item == exercise } || DemoExerciseAssignment.new(exercise).tap do |it|
      @exercise_assignments << it
      it.parent = @guide_assignment
    end
  end

  def current
    @current
  end

  def current_exercise_number
    current&.item&.number
  end

  def finished?
    @guide_assignment.finished?
  end

  def closed?
    @guide_assignment.closed?
  end
end
