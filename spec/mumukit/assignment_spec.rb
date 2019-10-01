require 'spec_helper'

describe Mumukit::Flow::Assignment do

  let(:exercises) { [
    DemoExercise.new(:learning),
    DemoExercise.new(:learning),
    DemoExercise.new(:practice)]
  }

  let!(:assignments) { assignments_for(exercises) }
  let(:assignment) { assignments[0] }

  describe 'submissions and difficulty' do
    context 'when an assignment is passed on one try' do
      before do
        assignment.accept_submission_status! :passed
      end

      it 'should count submissions accordingly' do
        expect(assignment.submissions_count).to eq 1
      end

      it 'should be easy' do
        expect(assignment.easy?).to be true
        expect(assignment.hard?).to be false
      end

      it 'should know its status' do
        expect(assignment.status).to eq :passed
      end
    end

    context 'when an assignment is passed after five tries' do
      before do
        4.times { assignment.accept_submission_status! :failed }
        assignment.accept_submission_status! :passed
      end

      it 'should count submissions accordingly' do
        expect(assignment.submissions_count).to eq 5
      end

      it 'should not be easy or hard' do
        expect(assignment.easy?).to be false
        expect(assignment.hard?).to be false
      end

      it 'should know its status' do
        expect(assignment.status).to eq :passed
      end
    end

    context 'when an assignment is passed after ten tries' do
      before do
        9.times { assignment.accept_submission_status! :failed }
        assignment.accept_submission_status! :passed
      end

      it 'should count submissions accordingly' do
        expect(assignment.submissions_count).to eq 10
      end

      it 'should be hard' do
        expect(assignment.easy?).to be false
        expect(assignment.hard?).to be true
      end

      it 'should know its status' do
        expect(assignment.status).to eq :passed
      end
    end

    context 'when an assignment is failed twice' do
      before do
        2.times { assignment.accept_submission_status! :failed }
      end

      it 'should count submissions accordingly' do
        expect(assignment.submissions_count).to eq 2
      end

      it 'should not be easy or hard' do
        pending("Currently true for easy as it's not checking if the assignment is passed")
        expect(assignment.easy?).to be false
        expect(assignment.hard?).to be false
      end

      it 'should know its status' do
        expect(assignment.status).to eq :failed
      end
    end
  end

  describe 'items' do
    context 'for the last assignment' do
      let(:assignment) { assignments[2] }

      it 'should know the assignments item' do
        expect(assignment.item).to eq exercises[2]
      end

      it 'should have no next items' do
        expect(assignment.next_items).to be_empty
      end
    end

    context 'for a non-trailing assignment' do
      it 'should know the assignments item' do
        expect(assignment.item).to eq exercises[0]
      end

      it 'should know the next items' do
        expect(assignment.next_items).to eq [exercises[1], exercises[2]]
      end
    end
  end

  describe 'exercises with same tags' do
    context 'when no exercises have been solved' do
      it 'should not suggest anything' do
        expect { assignment.next_item_suggestion }.to raise_error('can not suggest until closed')
      end
    end

    context 'when one exercise has been solved' do
      before do
        assignment.accept_submission_status! :passed
      end

      it 'should suggest to continue with the next exercise' do
        expect(assignment.next_suggested_item).to eq exercises[1]
        expect(assignment.next_item_suggestion).to be_a Mumukit::Flow::Suggestion::Continue
      end
    end

    context 'when two learning exercises of a certain tag were solved easily' do
      let(:assignment) { assignments[1] }

      before do
        assignments[0].accept_submission_status! :passed
        assignment.accept_submission_status! :passed
      end

      it 'should suggest to skip a third exercise' do
        expect(assignment.next_suggested_item).to eq exercises[2]
        expect(assignment.next_item_suggestion).to be_a Mumukit::Flow::Suggestion::Skip
      end
    end

    context 'when no exercises of a certain tag were solved easily' do
      let(:assignment) { assignments[1] }

      before do
        5.times { assignments[0].accept_submission_status! :passed }
        5.times { assignment.accept_submission_status! :passed }

        assignments[0].accept_submission_status! :passed
        assignment.accept_submission_status! :passed
      end

      it 'should suggest to continue with the next exercise' do
        expect(assignment.next_suggested_item).to eq exercises[2]
        expect(assignment.next_item_suggestion).to be_a Mumukit::Flow::Suggestion::Continue
      end
    end
  end
end
