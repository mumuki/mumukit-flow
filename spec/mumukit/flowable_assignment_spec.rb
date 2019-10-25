require 'spec_helper'

describe Mumukit::Flow::FlowableAssignment do
  let(:exercises) { [
    DemoExercise.new(:learning),
    DemoExercise.new(:learning),
    DemoExercise.new(:practice)]
  }

  let!(:assignments) { assignments_for(exercises) }
  let(:assignment) { assignments[0] }

  describe 'assignment is passed' do
    context 'in one try' do
      before do
        assignment.accept_submission_status! :passed
      end

      it 'should count submissions accordingly' do
        expect(assignment.submissions_count).to eq 1
      end

      it 'should know its status' do
        expect(assignment.status).to eq :passed
      end
    end

    context 'in five tries' do
      before do
        4.times { assignment.accept_submission_status! :failed }
        assignment.accept_submission_status! :passed
      end

      it 'should count submissions accordingly' do
        expect(assignment.submissions_count).to eq 5
      end

      it 'should know its status' do
        expect(assignment.status).to eq :passed
      end
    end

    context 'in ten tries' do
      before do
        9.times { assignment.accept_submission_status! :failed }
        assignment.accept_submission_status! :passed
      end

      it 'should count submissions accordingly' do
        expect(assignment.submissions_count).to eq 10
      end

      it 'should know its status' do
        expect(assignment.status).to eq :passed
      end
    end
  end

  describe 'assignment is failed' do
    before do
      assignment.accept_submission_status! :failed
    end

    it 'should count submissions accordingly' do
      expect(assignment.submissions_count).to eq 1
    end

    it 'should know its status' do
      expect(assignment.status).to eq :failed
    end
  end

  describe 'items' do
    context 'last assignment' do
      let(:assignment) { assignments[2] }

      it 'should know its item' do
        expect(assignment.item).to eq exercises[2]
      end

      it 'should have no next items' do
        expect(assignment.next_items).to be_empty
      end
    end

    context 'non-trailing assignment' do
      it 'should know its item' do
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

      context 'when the third exercise is practice' do
        it 'should suggest to skip it' do
          expect(assignment.next_suggested_item).to eq exercises[2]
          expect(assignment.next_item_suggestion).to be_a Mumukit::Flow::Suggestion::Skip
        end
      end

      context 'when the third exercise is learning' do
        before do
          exercises[2] = DemoExercise.new(:learning)
          assignments_for(exercises)
        end

        it 'should suggest to continue with it' do
          expect(assignment.next_suggested_item).to eq exercises[2]
          expect(assignment.next_item_suggestion).to be_a Mumukit::Flow::Suggestion::Continue
        end
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

  describe 'exercises with different tags' do
    context 'when exercise with tag A and exercise with tag B were solved easily' do
      let(:exercises) { [
          DemoExercise.new(:learning, ['A']),
          DemoExercise.new(:learning, ['B']),
          DemoExercise.new(:practice)]
      }

      let!(:assignments) { assignments_for(exercises) }
      let(:assignment) { assignments[1] }

      before do
        assignments[0].accept_submission_status! :passed
        assignment.accept_submission_status! :passed
      end

      it 'should suggest continuing with the next exercise whatever its tag' do
        expect(assignment.next_suggested_item).to eq exercises[2]
        expect(assignment.next_item_suggestion).to be_a Mumukit::Flow::Suggestion::Continue
      end
    end

    context 'when exercise with tag AB and exercise with tag A were solved easily' do
      let(:exercises) { [
          DemoExercise.new(:learning, ['A', 'B']),
          DemoExercise.new(:learning, ['A'])]
      }

      let!(:assignments) { assignments_for(exercises) }
      let!(:assignment) { assignments[1] }

      before do
        assignments[0].accept_submission_status! :passed
        assignment.accept_submission_status! :passed
      end

      context 'next exercise is learning with any tag' do
        before do
          exercises[2] = DemoExercise.new(:learning)
          assignments_for(exercises)
        end

        it 'should suggest continuing' do
          expect(assignment.next_suggested_item).to eq exercises[2]
          expect(assignment.next_item_suggestion).to be_a Mumukit::Flow::Suggestion::Continue
        end
      end

      context 'next exercise is practice with tag A' do
        before do
          exercises[2] = DemoExercise.new(:practice, ['A'])
          assignments_for(exercises)
        end

        it 'should suggest skipping' do
          expect(assignment.next_suggested_item).to eq exercises[2]
          expect(assignment.next_item_suggestion).to be_a Mumukit::Flow::Suggestion::Skip
        end
      end

      context 'next exercise is practice with tag B' do
        before do
          exercises[2] = DemoExercise.new(:practice, ['B'])
          assignments_for(exercises)
        end

        it 'should suggest continuing' do
          expect(assignment.next_suggested_item).to eq exercises[2]
          expect(assignment.next_item_suggestion).to be_a Mumukit::Flow::Suggestion::Continue
        end
      end

      context 'next exercise is practice with tag AB' do
        before do
          exercises[2] = DemoExercise.new(:practice, ['A', 'B'])
          assignments_for(exercises)
        end

        it 'should suggest continuing' do
          expect(assignment.next_suggested_item).to eq exercises[2]
          expect(assignment.next_item_suggestion).to be_a Mumukit::Flow::Suggestion::Continue
        end
      end
    end
  end
end
