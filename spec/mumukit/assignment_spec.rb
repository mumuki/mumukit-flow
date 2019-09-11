require 'spec_helper'

describe Mumukit::Flow::Assignment do
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
          assignment.accept_submission_status! :passed
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
          assignment.accept_submission_status! :passed
        end

        it { expect(assignment.item).to eq exercises[2] }
        it { expect(assignment.next_item).to eq nil }
        it { expect(assignment.next_items).to eq [] }

        it { expect(assignment.next_suggested_item).to eq nil }
        it { expect(assignment.next_item_suggestion).to be Mumukit::Flow::Suggestion::None }
      end

      context 'when previous exercises have being hard to solve' do
        before do
          exercise_assignments[0].accept_submission_status! :passed
          11.times { exercise_assignments[1].accept_submission_status! :failed }
          exercise_assignments[1].accept_submission_status! :passed
          assignment.accept_submission_status! :passed
        end

        it { expect(assignment.item).to eq exercises[2] }
        it { expect(assignment.next_item).to eq nil }
        it { expect(assignment.next_items).to eq [] }

        it { expect(assignment.next_suggested_item).to eq nil }
        it { expect(assignment.next_item_suggestion).to be Mumukit::Flow::Suggestion::None }
      end

      context 'when there is a single pending exercises' do
        before do
          exercise_assignments[0].accept_submission_status! :passed
          assignment.accept_submission_status! :passed
        end

        it { expect(assignment.item).to eq exercises[2] }
        it { expect(assignment.next_item).to eq nil }
        it { expect(assignment.next_items).to eq [] }

        it { expect(assignment.next_suggested_item).to eq exercises[1] }
        it { expect(assignment.next_item_suggestion).to be_a Mumukit::Flow::Suggestion::Revisit }
      end

      context 'when there are multiple pending exercises' do
        before do
          assignment.accept_submission_status! :passed
        end

        it { expect(assignment.item).to eq exercises[2] }
        it { expect(assignment.next_item).to eq nil }
        it { expect(assignment.next_items).to eq [] }

        it { expect(assignment.next_suggested_item).to eq exercises[0] }
        it { expect(assignment.next_item_suggestion).to be_a Mumukit::Flow::Suggestion::Revisit }
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

          it { expect(assignment.next_suggested_item).to eq exercises[2] }
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

          it { expect(assignment.next_suggested_item).to eq exercises[1] }
          it { expect(assignment.next_item_suggestion).to be_a Mumukit::Flow::Suggestion::Continue }
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
          it { expect(assignment.next_suggested_item).to be_practice }

          it { expect(assignment.item).to eq exercises[0] }
          it { expect(assignment.next_item).to eq exercises[1] }

          it { expect(assignment.parent).to eq guide_assignment }
          it { expect(assignment.siblings).to eq [exercise_assignments[1], exercise_assignments[2]] }
          it { expect(assignment.sibling_items).to eq [exercises[1], exercises[2]] }

          it { expect(assignment.next_items).to eq [exercises[1], exercises[2]] }


          it { expect(assignment.next_suggested_item).to eq exercises[1] }
          it { expect(assignment.next_item_suggestion).to be_a Mumukit::Flow::Suggestion::Continue }
        end

        context 'when there is no exercise that matches the suggestion' do
          let(:assignment) { exercise_assignments[1] }

           before do
            10.times { assignment.accept_submission_status! :failed }
            assignment.accept_submission_status! :passed
          end

          it { expect(assignment.hard?).to be true }
          it { expect(assignment.next_item_suggestion_type).to eq :practice }

          it { expect(assignment.next_item).to eq exercises[2] }

          it { expect(assignment.next_item_suggestion_type).to eq :practice }
          it { expect(assignment.next_suggested_item).to be_learning }

          it { expect(assignment.next_suggested_item).to eq exercises[2] }
          it { expect(assignment.next_item_suggestion).to be_a Mumukit::Flow::Suggestion::Continue }
        end
      end
    end
  end
end
