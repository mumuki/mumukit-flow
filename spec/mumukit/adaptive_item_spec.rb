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
  let(:exercise) { exercises.first }
  let(:practice_exercise) { exercises.third }
  let(:last_exercise) { exercises.last }

  describe '#tagged_as?' do
    context 'with some tags it does have' do
      it { expect(exercise.tagged_as? 'A').to be true }
      it { expect(exercise.tagged_as? 'B').to be true }
    end

    context 'with a tag it does not have' do
      it { expect(exercise.tagged_as? 'C').to be false }
    end
  end

  describe '#skippable?' do
    context 'when an exercise is learning' do
      it { expect(exercise.skippable?).to be false }
    end

    context 'when an exercise is practice' do
      it { expect(practice_exercise.skippable?).to be true }
    end
  end

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
end
