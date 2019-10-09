require 'spec_helper'

describe 'difficulty' do
  let(:exercises) { [ DemoExercise.new(:learning) ] }

  let(:assignments) { assignments_for(exercises) }
  let(:assignment) { assignments[0] }

  describe 'passing an assignment' do
    context 'with no failures' do
      before do
        assignment.accept_submission_status! :passed
      end

      it 'should be easy' do
        expect(assignment.easy?).to be true
        expect(assignment.hard?).to be false
      end
    end

    context 'with two failures' do
      before do
        2.times { assignment.accept_submission_status! :failed }
        assignment.accept_submission_status! :passed
      end

      it 'should be easy' do
        expect(assignment.easy?).to be true
        expect(assignment.hard?).to be false
      end
    end

    context 'with three failures' do
      before do
        3.times { assignment.accept_submission_status! :failed }
        assignment.accept_submission_status! :passed
      end

      it 'should not be easy or hard' do
        expect(assignment.easy?).to be false
        expect(assignment.hard?).to be false
      end
    end

    context 'with ten failures' do
      before do
        10.times { assignment.accept_submission_status! :failed }
        assignment.accept_submission_status! :passed
      end

      it 'should be hard' do
        expect(assignment.easy?).to be false
        expect(assignment.hard?).to be true
      end
    end
  end

  describe 'failing an assignment' do
    context 'once' do
      before do
        assignment.accept_submission_status! :failed
      end

      it 'should not be easy or hard' do
        expect(assignment.easy?).to be false
        expect(assignment.hard?).to be false
      end
    end

    context 'three times' do
      before do
        3.times { assignment.accept_submission_status! :failed }
      end

      it 'should not be easy or hard' do
        expect(assignment.easy?).to be false
        expect(assignment.hard?).to be false
      end
    end

    context 'ten times' do
      before do
        10.times { assignment.accept_submission_status! :failed }
      end

      it 'should be hard' do
        expect(assignment.easy?).to be false
        expect(assignment.hard?).to be true
      end
    end
  end
end
