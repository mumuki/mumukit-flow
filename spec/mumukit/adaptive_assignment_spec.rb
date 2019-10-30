require 'spec_helper'

describe Mumukit::Flow::AdaptiveAssignment do
  let(:exercise) { DemoExercise.new(:learning) }
  let(:assignment) { exercise.assignment }

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
end