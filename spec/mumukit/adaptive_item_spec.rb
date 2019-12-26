require 'spec_helper'

describe Mumukit::Flow::AdaptiveItem do
  let(:exercises) { [
      DemoExercise.new(:learning, ['A', 'B']),
      DemoExercise.new(:learning),
      DemoExercise.new(:practice),
      DemoExercise.new(:learning),
      DemoExercise.new(:learning)
  ] }
  let!(:guide) { DemoGuide.new(exercises) }
  let(:submitter) { 'a student' }
  let(:exercise) { exercises[0] }
  let(:last_exercise) { exercises.last }

  describe '#end_reached?' do
    context 'when the last exercise has been solved' do
      before { last_exercise.accept_submission_status! :passed }

      it { expect(last_exercise.end_reached?).to be true }
    end

    context 'when an exercise not last has been solved' do
      before { exercise.accept_submission_status! :passed }

      it { expect(exercise.end_reached?).to be false }
    end
  end

  describe '#next_item' do
    context 'when asked to the last exercise' do
      it { expect(last_exercise.next_item).to be nil }
    end

    context 'when asked to an exercise not last' do
      it 'is the following exercise' do
        expect(exercise.next_item).to eq exercises[1]
      end
    end
  end

  describe '#pending_siblings?' do
    context 'when all exercises have been solved' do
      before do
        exercises.each { |exercise| exercise.accept_submission_status! :passed }
      end

      it { expect(exercise.pending_siblings?).to be false }
    end

    context 'when one or more exercises have failed' do
      before do
        exercises.each { |exercise| exercise.accept_submission_status! :failed }
      end

      it { expect(exercise.pending_siblings?).to be true }
    end

    context 'when one or more exercises remain pending' do
      it { expect(exercise.pending_siblings?).to be true }
    end
  end

  describe '#passed_siblings_by' do
    context 'when no exercise has been solved' do
      it 'there are no passed assignments' do
        expect(guide.passed_siblings_by(submitter).empty?).to be true
      end
    end

    context 'when a couple exercises have been solved' do
      before do
        exercises[2].accept_submission_status! :passed
        exercises[3].accept_submission_status! :passed
      end

      it 'there are a couple passed assignments' do
        siblings = guide.passed_siblings_by(submitter)

        expect(siblings.size).to eq 2
        expect(siblings.first).to eq exercises[2].assignment
        expect(siblings.second).to eq exercises[3].assignment
      end
    end
  end

  describe '#has?' do
    context 'with some tags it does have' do
      it { expect(exercise.has? 'A').to be true }
      it { expect(exercise.has? 'B').to be true }
    end

    context 'with a tag it does not have' do
      it { expect(exercise.has? 'C').to be false }
    end
  end
end
