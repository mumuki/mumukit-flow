require 'spec_helper'

describe Mumukit::Flow::AdaptiveItem do
  let(:exercises) { [
      DemoExercise.new(:learning),
      DemoExercise.new(:learning),
      DemoExercise.new(:practice)]
  }

  let(:exercise) { exercises[0] }
  let(:assignment) { exercise.assignment }

  describe 'exercises with same tags' do
    context 'when no exercises have been solved' do
      it 'should not suggest anything' do
        expect { exercise.next_item_suggestion }.to raise_error('can not suggest until closed')
      end
    end
  end
end
