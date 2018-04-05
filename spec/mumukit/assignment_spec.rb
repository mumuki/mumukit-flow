require 'spec_helper'

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

describe Mumukit::Flow::Assignment::Helpers do
  context 'incomplete assignments' do
    pending
  end
  context 'complete assignments' do
    let!(:guide) { DemoGuide.new(exercises) }
    let(:exercises) { [
      DemoExercise.new(:learning),
      DemoExercise.new(:practice),
      DemoExercise.new(:learning)
    ] }

    let!(:guide_assignment) { DemoGuideAssignment.new(guide, exercise_assignments) }
    let(:exercise_assignments) { [
      DemoExerciseAssignment.new(exercises[0]),
      DemoExerciseAssignment.new(exercises[1]),
      DemoExerciseAssignment.new(exercises[2])
    ] }

    context 'when item is last in path' do
      let(:assignment) { exercise_assignments[2] }

      context 'when previous exercises have being solved easily' do
        before do
          exercise_assignments[0].accept_submission_status! :passed
          exercise_assignments[1].accept_submission_status! :passed
        end

        it { expect(assignment.item).to eq exercises[2] }
        it { expect(assignment.next_item).to eq nil }
        it { expect(assignment.next_items).to eq [] }

        it { expect(assignment.next_item_suggestion).to be Mumukit::Flow::Suggestion::None }
      end

      context 'when previous exercises have being normally solved' do
        before do
          exercise_assignments[0].accept_submission_status! :passed
          5.times { exercise_assignments[1].accept_submission_status! :failed }
          exercise_assignments[1].accept_submission_status! :passed
        end

        it { expect(assignment.item).to eq exercises[2] }
        it { expect(assignment.next_item).to eq nil }
        it { expect(assignment.next_items).to eq [] }

        pending { expect(assignment.next_item_suggestion.item).to eq exercises[1] }
        pending { expect(assignment.next_item_suggestion).to be_a Mumukit::Flow::Suggestion::Retry }
      end

      context 'when previous exercises have being hard to solve' do
        before do
          exercise_assignments[0].accept_submission_status! :passed
          11.times { exercise_assignments[1].accept_submission_status! :failed }
          exercise_assignments[1].accept_submission_status! :passed
        end

        it { expect(assignment.item).to eq exercises[2] }
        it { expect(assignment.next_item).to eq nil }
        it { expect(assignment.next_items).to eq [] }

        pending { expect(assignment.next_item_suggestion.item).to eq exercises[1] }
        pending { expect(assignment.next_item_suggestion).to be_a Mumukit::Flow::Suggestion::Retry }
      end
    end

    context 'when item is not last in path' do
      let(:assignment) { exercise_assignments[0] }

      describe 'practice suggestion flow' do
        context 'assignment is easy' do
          before do
            assignment.accept_submission_status! :failed
            assignment.accept_submission_status! :failed
            assignment.accept_submission_status! :passed
          end

          it { expect(assignment.submissions_count).to eq 3 }
          it { expect(assignment.status).to eq :passed }
          it { expect(assignment.easy?).to be true }
          it { expect(assignment.hard?).to be false }
          it { expect(assignment.should_retry?).to be false }
          it { expect(assignment.next_item_suggestion_type).to eq :learning }

          it { expect(assignment.item).to eq exercises[0] }
          it { expect(assignment.next_item).to eq exercises[1] }
          it { expect(assignment.next_items).to eq [exercises[1], exercises[2]] }

          it { expect(assignment.next_item_suggestion.item).to eq exercises[2] }
          it { expect(assignment.next_item_suggestion).to be_a Mumukit::Flow::Suggestion::FastForward }
        end

        context 'assignment is normal' do
          before do
            5.times { assignment.accept_submission_status! :failed }
            assignment.accept_submission_status! :passed
          end

          it { expect(assignment.submissions_count).to eq 6 }
          it { expect(assignment.status).to eq :passed }
          it { expect(assignment.easy?).to be false }
          it { expect(assignment.hard?).to be false }
          it { expect(assignment.should_retry?).to be false }
          it { expect(assignment.next_item_suggestion_type).to eq :practice }

          it { expect(assignment.item).to eq exercises[0] }
          it { expect(assignment.next_item).to eq exercises[1] }
          it { expect(assignment.next_items).to eq [exercises[1], exercises[2]] }

          it { expect(assignment.next_item_suggestion.item).to eq exercises[1] }
          it { expect(assignment.next_item_suggestion).to be_a Mumukit::Flow::Suggestion::Continue }
        end

        context 'when there is no exercise that matches the suggestion' do
          pending
        end

        context 'assignment is hard' do
          before do
            10.times { assignment.accept_submission_status! :failed }
            assignment.accept_submission_status! :passed
          end

          it { expect(assignment.submissions_count).to eq 11 }
          it { expect(assignment.status).to eq :passed }
          it { expect(assignment.easy?).to be false }
          it { expect(assignment.hard?).to be true }
          it { expect(assignment.should_retry?).to be true }
          it { expect(assignment.next_item_suggestion_type).to eq :practice }

          it { expect(assignment.item).to eq exercises[0] }
          it { expect(assignment.next_item).to eq exercises[1] }

          it { expect(assignment.parent).to eq guide_assignment }
          it { expect(assignment.siblings).to eq [exercise_assignments[1], exercise_assignments[2]] }
          it { expect(assignment.sibling_items).to eq [exercises[1], exercises[2]] }

          it { expect(assignment.next_items).to eq [exercises[1], exercises[2]] }

          it { expect(assignment.next_item_suggestion.item).to eq exercises[1] }
          it { expect(assignment.next_item_suggestion).to be_a Mumukit::Flow::Suggestion::Continue }
        end
      end
    end
  end
end
