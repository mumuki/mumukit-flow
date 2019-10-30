require 'spec_helper'

describe Mumukit::Flow::AdaptiveItem do
  let(:exercises) { [
      DemoExercise.new(:learning),
      DemoExercise.new(:learning),
      DemoExercise.new(:practice)]
  }

  let!(:guide) { DemoGuide.new(exercises) }

  let(:exercise) { exercises[0] }
  let!(:assignment) { exercise.assignment }

  describe 'exercises with same tags' do
    context 'when no exercises have been solved' do
      it 'should not suggest anything' do
        expect { exercise.next_item_suggestion }.to raise_error('can not suggest until closed')
      end
    end

    context 'when one exercise has been solved' do
      before do
        assignment.accept_submission_status! :passed
      end

      it 'should suggest to continue with the next exercise' do
        expect(exercise.next_suggested_item).to eq exercises[1]
        expect(exercise.next_item_suggestion).to be_a Mumukit::Flow::Suggestion::Continue
      end
    end
  end
end
